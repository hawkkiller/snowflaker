import 'package:snowflaker/snowflaker.dart';

void main(List<String> args) {
  final snowflaker = Snowflaker(
    workerId: 1,
    datacenterId: 1,
  );

  final id = snowflaker.nextId();
  final id2 = snowflaker.nextId();

  print('id: $id');
  print('id2: $id2');
}