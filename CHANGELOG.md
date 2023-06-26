# Changelog

All notable changes to this project will be documented in this file.

## [1.1.0] - 2023-06-26

- Created interface for `Snowflaker`

## [1.0.3] - 2023-06-9

### Changed

- Added @visibleForTesting to `lastTimestamp` and `tilNextMillis` methods.
- Made `sequence` private.

## [1.0.2] - 2023-06-8

### Changed

- Updated bin/snowflaker.dart

## [1.0.1] - 2023-06-8

### Changed

- Updated pubspec.yaml to have a more accurate description of the library.
- Fixed name of the class from `Snoflaker` to `Snowflaker`.

### Added

- Created example

## [1.0.0] - 2023-06-08

### Added

- Initial release of the snowflaker ID generator.
- Thread-safe generation of unique IDs.
- Each ID contains a timestamp with millisecond precision.
- Customizable worker and datacenter identifiers.
- Unit tests for primary functionalities.
