import 'dart:async';

import 'package:snowflake/snowflake.dart';

void main(List<String> arguments) {
  final snowflake = Snowflake(
    workerId: 1,
    datacenterId: 1,
  );
  final id = snowflake.nextId();
  final id2 = snowflake.nextId();
  Zone.current.print('id: $id');
  Zone.current.print('id2: $id2');
}
