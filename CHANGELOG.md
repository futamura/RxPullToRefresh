# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0]

A maintenance release that brings the library up to the current iOS toolchain.
The public API is unchanged — every breaking item below is about how the library
is built and installed.

### Migration guide

**1. Switch to Swift Package Manager.**

CocoaPods and Carthage support is gone. Remove the `pod 'RxPullToRefresh'` line
from your `Podfile` or the `github "futamura/RxPullToRefresh"` line from your
`Cartfile`, then add the package in Xcode via **File > Add Package Dependencies…**
with `https://github.com/futamura/RxPullToRefresh.git`, or in `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/futamura/RxPullToRefresh.git", from: "2.0.0")
]
```

Version 1.0.1 remains on the CocoaPods trunk for existing projects, but it will
not receive updates.

**2. Raise your deployment target to iOS 13.**

**3. Move to RxSwift 6.** If your own code touches RxSwift, the rename that
affects this library's usage patterns is `takeUntil(_:)` → `take(until:)`.
See the [RxSwift 6.0.0 release notes](https://github.com/ReactiveX/RxSwift/releases/tag/6.0.0)
for the full list.

**4. If you subclass `UITableViewController`**, clear the delegate before handing
it to RxCocoa, or RxCocoa's debug assertion will trap:

```swift
tableView.delegate = nil
tableView.dataSource = nil
tableView.rx.setDelegate(self).disposed(by: disposeBag)
```

This was always required; it only surfaced now because release-built dependencies
used to strip the assertion.

### Changed

- **BREAKING** Minimum deployment target raised from iOS 10.0 to iOS 13.0.
- **BREAKING** RxSwift and RxCocoa dependency raised from 5.x to 6.x.
- **BREAKING** Minimum Swift version raised from 5.0 to 5.9.
- Documentation is now generated with DocC and published to GitHub Pages on
  every push to `master`, replacing the jazzy site committed under `docs/`.

### Added

- Swift Package Manager support via `Package.swift`.
- GitHub Actions workflows for tests, example build, SwiftLint, and docs.

### Removed

- **BREAKING** CocoaPods support (`RxPullToRefresh.podspec`).
- **BREAKING** Carthage support (`Cartfile` and related manifests).
- Travis CI configuration, superseded by GitHub Actions.
- Ruby toolchain (bundler, fastlane, slather), jazzy configuration and theme,
  Hound and Codecov configuration, and assorted helper scripts.

### Fixed

- Example app crashed on launch under a debug-built RxCocoa because
  `UITableViewController` and the storyboard both wired the table view delegate
  before `rx.setDelegate(_:)` ran.
- Missing `UIKit` imports in `Debug.swift` and `Enums.swift`, which only surfaced
  when building through Swift Package Manager.
- Deprecated `UIActivityIndicatorView.Style.gray` replaced with `.medium`.

## [1.0.1]

See the [release history](https://github.com/futamura/RxPullToRefresh/releases)
for versions up to 1.0.1.

[2.0.0]: https://github.com/futamura/RxPullToRefresh/compare/1.0.1...2.0.0
[1.0.1]: https://github.com/futamura/RxPullToRefresh/releases/tag/1.0.1
