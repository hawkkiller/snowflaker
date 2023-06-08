library snowflake;

class Snowflake {
  Snowflake({
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
  static const int timestampLeftShift = sequenceBits + workerIdBits + datacenterIdBits;

  /// A mask that can be used to get the sequence number.
  static const int sequenceMask = -1 ^ (-1 << sequenceBits);

  /// The worker ID.
  final int workerId;

  /// The data center ID.
  final int datacenterId;

  /// This is the custom epoch time, it's the start time from where the timestamp begins.
  /// All timestamps are the number of milliseconds since this point.
  final int epoch;

  /// The sequence number for the ID.
  int sequence = 0;

  /// The last timestamp that was used to generate an ID.
  int lastTimestamp = -1;

  int get timestamp => DateTime.now().millisecondsSinceEpoch;

  int nextId() {
    var timestamp = this.timestamp;

    if (timestamp < lastTimestamp) {
      throw ArgumentError(
        'Clock moved backwards. Refusing to generate id for ${lastTimestamp - timestamp} milliseconds',
      );
    }

    if (lastTimestamp == timestamp) {
      sequence = (sequence + 1) & sequenceMask;
      if (sequence == 0) {
        timestamp = tilNextMillis(lastTimestamp);
      }
    } else {
      sequence = 0;
    }
    lastTimestamp = timestamp;

    return ((timestamp - epoch) << timestampLeftShift) |
        (datacenterId << datacenterIdShift) |
        (workerId << workerIdShift) |
        sequence;
  }

  int tilNextMillis(int lastTimestamp) {
    var timestamp = this.timestamp;
    while (timestamp <= lastTimestamp) {
      timestamp = this.timestamp;
    }
    return timestamp;
  }
}
