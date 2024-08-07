# Change Log
All notable changes to this project will be documented in this file.
`ADUtils` adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

## [1.1.0] - 2024-07-01

### Added
- Add Support for Swift Concurrency

### Removed

- Remove support for iOS 10, 11 and 12
- Remove support for tvOS 10, 11 and 12

### Changed

- Add @MainActor attribute to Coordinator
- Add @MainActor attribute to NativeNavigator
- Update Example project to pass strict concurrency checks

## [1.0.2] - 2021-09-10

- Add SPM compatibility

## [1.0.1] - 2020-11-19

### Fixed

- Fix deallocation handling when changing parent [#4](https://github.com/faberNovel/Coordinator/pull/3) by [alexandre-pod](https://github.com/alexandre-pod)

## [1.0.0] - 2020-02-20

Initial release
