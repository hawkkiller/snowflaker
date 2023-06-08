import 'dart:async';

import 'package:snowflaker/snowflaker.dart';

void main(List<String> arguments) {
  final snowflaker = Snoflaker(
    workerId: 1,
    datacenterId: 1,
  );
  final id = snowflaker.nextId();
  final id2 = snowflaker.nextId();
  Zone.current.print('id: $id');
  Zone.current.print('id2: $id2');
}
