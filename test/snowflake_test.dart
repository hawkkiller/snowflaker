import 'package:snowflake/snowflake.dart';
import 'package:test/test.dart';

void main() {
  group('Snowflake', () {
    late Snowflake snowflake1;
    late Snowflake snowflake2;

    setUp(() {
      snowflake1 = Snowflake(
        workerId: 1,
        datacenterId: 1,
      );
      snowflake2 = Snowflake(
        workerId: 2,
        datacenterId: 2,
      );
    });

    test('should create unique ids for different instances', () {
      final id1 = snowflake1.nextId();
      final id2 = snowflake2.nextId();

      expect(id1, isNot(equals(id2)));
    });

    test('should create unique ids for same instance', () {
      final id1 = snowflake1.nextId();
      final id2 = snowflake1.nextId();

      expect(id1, isNot(equals(id2)));
    });

    test('should throw error if clock moves backwards', () {
      final timeBefore = snowflake1.timestamp;
      snowflake1.lastTimestamp = timeBefore + 1100;

      expect(() => snowflake1.nextId(), throwsA(isA<ArgumentError>()));
    });

    test('should throw error if workerId exceeds limit', () {
      expect(
        () => Snowflake(
          workerId: Snowflake.maxWorkerId + 1,
          datacenterId: 0,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('should throw error if workerId is less than 0', () {
      expect(
        () => Snowflake(
          workerId: -1,
          datacenterId: 0,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('should throw error if datacenterId exceeds limit', () {
      expect(
        () => Snowflake(
          workerId: 0,
          datacenterId: Snowflake.maxDatacenterId + 1,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('should throw error if datacenterId is less than 0', () {
      expect(
        () => Snowflake(
          workerId: 0,
          datacenterId: -1,
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
