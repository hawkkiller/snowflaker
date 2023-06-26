import 'package:snowflaker/snowflaker.dart';
import 'package:test/test.dart';

void main() {
  group('Snowflaker >', () {
    late Snowflaker snowflaker1;
    late Snowflaker snowflaker2;

    setUp(() {
      snowflaker1 = Snowflaker(
        workerId: 1,
        datacenterId: 1,
      );
      snowflaker2 = Snowflaker(
        workerId: 2,
        datacenterId: 2,
      );
    });

    test('Should create unique ids for different instances', () {
      final id1 = snowflaker1.nextId();
      final id2 = snowflaker2.nextId();

      expect(id1, isNot(equals(id2)));
    });

    test('Should create unique ids for same instance', () {
      final id1 = snowflaker1.nextId();
      final id2 = snowflaker1.nextId();

      expect(id1, isNot(equals(id2)));
    });

    test('Should throw error if workerId is less than 0', () {
      expect(
        () => Snowflaker(
          workerId: -1,
          datacenterId: 0,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('Should throw error if datacenterId is less than 0', () {
      expect(
        () => Snowflaker(
          workerId: 0,
          datacenterId: -1,
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
