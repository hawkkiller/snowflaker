# Snowflake ID Generator

A Dart library for generating unique, sortable ID strings using the Twitter's Snowflake algorithm.

## Features

* Thread-safe generation of unique IDs.
* Each ID contains a timestamp with millisecond precision.
* Customizable worker and datacenter identifiers.

## Usage

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  snowflaker: ^1.0.0
```

Then import the library:

```dart
import 'package:snowflaker/snowflaker.dart';
```

To generate a new ID, create a new instance of `snowflaker` and call its `nextId()` method:

```dart

// Create a new instance of snowflaker with a worker ID of 1 and a datacenter ID of 1.
final snowflaker = Snowflaker(workerId: 1, datacenterId: 1);

// Generate a new ID.
final id = snowflaker.nextId();
```
