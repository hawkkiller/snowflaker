import 'package:snowflaker/snowflaker.dart';
import 'package:test/test.dart';

void main() {
  group('snowflaker', () {
    late Snoflaker snowflaker1;
    late Snoflaker snowflaker2;

    setUp(() {
      snowflaker1 = Snoflaker(
        workerId: 1,
        datacenterId: 1,
      );
      snowflaker2 = Snoflaker(
        workerId: 2,
        datacenterId: 2,
      );
    });

    test('should create unique ids for different instances', () {
      final id1 = snowflaker1.nextId();
      final id2 = snowflaker2.nextId();

      expect(id1, isNot(equals(id2)));
    });

    test('should create unique ids for same instance', () {
      final id1 = snowflaker1.nextId();
      final id2 = snowflaker1.nextId();

      expect(id1, isNot(equals(id2)));
    });

    test('should throw error if clock moves backwards', () {
      final timeBefore = snowflaker1.timestamp;
      snowflaker1.lastTimestamp = timeBefore + 1100;

      expect(() => snowflaker1.nextId(), throwsA(isA<ArgumentError>()));
    });

    test('should throw error if workerId exceeds limit', () {
      expect(
        () => Snoflaker(
          workerId: Snoflaker.maxWorkerId + 1,
          datacenterId: 0,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('should throw error if workerId is less than 0', () {
      expect(
        () => Snoflaker(
          workerId: -1,
          datacenterId: 0,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('should throw error if datacenterId exceeds limit', () {
      expect(
        () => Snoflaker(
          workerId: 0,
          datacenterId: Snoflaker.maxDatacenterId + 1,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('should throw error if datacenterId is less than 0', () {
      expect(
        () => Snoflaker(
          workerId: 0,
          datacenterId: -1,
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
