library snowflaker;

import 'package:meta/meta.dart';

abstract interface class Snowflaker {
  factory Snowflaker({
    required int workerId,
    required int datacenterId,
    int epoch,
  }) = _SnowflakerImpl;

  /// The worker ID.
  int get workerId;

  /// The data center ID.
  int get datacenterId;

  /// This is the custom epoch time,
  ///
  ///  it's the start time from where the timestamp begins.
  int get epoch;

  /// Generate new snowflake ID.
  int nextId();
}

final class _SnowflakerImpl implements Snowflaker {
  _SnowflakerImpl({
    required this.workerId,
    required this.datacenterId,
    this.epoch = twepoch,
  })  : assert(
          workerId <= maxWorkerId && workerId >= 0,
          "worker Id can't be greater than $maxWorkerId or less than 0",
        ),
        assert(
          datacenterId <= maxDatacenterId && datacenterId >= 0,
          "datacenter Id can't be greater than $maxDatacenterId or less than 0",
        );

  static const int twepoch = 1288834974657;

  /// The number of bits that the worker ID takes up.
  static const int workerIdBits = 5;

  /// The number of bits that the data center ID takes up.
  static const int datacenterIdBits = 5;

  /// The number of bits that the sequence number takes up.
  static const int sequenceBits = 12;

  /// The maximum value that the worker ID can have.
  static const int maxWorkerId = -1 ^ (-1 << workerIdBits);

  /// The maximum value that the data center ID can have.
  static const int maxDatacenterId = -1 ^ (-1 << datacenterIdBits);

  /// The number of bits to shift to the left when constructing the ID to place the worker ID.
  static const int workerIdShift = sequenceBits;

  /// The number of bits to shift to the left when constructing the ID to place the data center ID.
  static const int datacenterIdShift = sequenceBits + workerIdBits;

  /// The number of bits to shift to the left when constructing the ID to place the timestamp.
  static const int timestampLeftShift =
      sequenceBits + workerIdBits + datacenterIdBits;

  /// A mask that can be used to get the sequence number.
  static const int sequenceMask = -1 ^ (-1 << sequenceBits);

  /// The worker ID.
  @override
  final int workerId;

  /// The data center ID.
  @override
  final int datacenterId;

  /// This is the custom epoch time, it's the start time from where the timestamp begins.
  /// All timestamps are the number of milliseconds since this point.
  @override
  final int epoch;

  /// The sequence number for the ID.
  int _sequence = 0;

  /// The last timestamp that was used to generate an ID.
  int lastTimestamp = -1;

  int get _nowTimestamp => DateTime.now().millisecondsSinceEpoch;

  @override
  int nextId() {
    var timestamp = _nowTimestamp;

    if (timestamp < lastTimestamp) {
      throw ArgumentError(
        'Clock moved backwards. Refusing to generate id for ${lastTimestamp - timestamp} milliseconds',
      );
    }

    if (lastTimestamp == timestamp) {
      _sequence = (_sequence + 1) & sequenceMask;
      if (_sequence == 0) {
        timestamp = tilNextMillis(lastTimestamp);
      }
    } else {
      _sequence = 0;
    }
    lastTimestamp = timestamp;

    return ((timestamp - epoch) << timestampLeftShift) |
        (datacenterId << datacenterIdShift) |
        (workerId << workerIdShift) |
        _sequence;
  }

  @visibleForTesting
  int tilNextMillis(int lastTimestamp) {
    var timestamp = _nowTimestamp;
    while (timestamp <= lastTimestamp) {
      timestamp = _nowTimestamp;
    }
    return timestamp;
  }
}
