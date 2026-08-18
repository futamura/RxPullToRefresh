# Contributing

Thanks for taking the time. Bug reports, documentation fixes, and pull requests
are all welcome.

## Before you start

For anything larger than a bug fix, open an issue first so we can agree on the
approach. The public API is deliberately small, and `RxPullToRefreshView` is meant
to be subclassed — many customisations are possible without adding to the API.

## Getting set up

- Xcode 15 or later, targeting iOS 13.0 as the minimum deployment target
- Open `RxPullToRefresh.xcodeproj`; Swift Package Manager resolves RxSwift,
  RxDataSources, Quick, and Nimble automatically
- Install [SwiftLint](https://github.com/realm/SwiftLint) (`brew install swiftlint`)

`Package.swift` exists for distribution and builds only the `Sources/` directory.
Day-to-day development happens in the Xcode project, which additionally holds the
test, example, and UI test targets.

## Running the checks

Simulator names vary by machine; run `xcrun simctl list devices available` and
substitute one of your own.

```bash
# Unit tests — the ones CI runs on every pull request
xcodebuild test -project RxPullToRefresh.xcodeproj -scheme RxPullToRefresh \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  -only-testing:RxPullToRefreshTests

# Example app build
xcodebuild build -project RxPullToRefresh.xcodeproj -scheme RxPullToRefreshExample \
  -destination 'generic/platform=iOS Simulator'

# Lint
swiftlint lint --strict

# UI tests — roughly 15 minutes, so CI only runs them on master.
# Pass -derivedDataPath explicitly: without it, any other Xcode activity can
# clear the build products mid-run and the tests fail to launch.
xcodebuild test -project RxPullToRefresh.xcodeproj -scheme RxPullToRefresh \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  -only-testing:RxPullToRefreshUITests -derivedDataPath DerivedData
```

Run the UI tests locally whenever your change touches scroll handling, state
transitions, or the example app.

## Writing tests

Tests use [Quick](https://github.com/Quick/Quick) 7 and
[Nimble](https://github.com/Quick/Nimble) 13:

- Specs are declared in `override class func spec()`. The instance form was
  removed in Quick 6, and `continueAfterFailure` cannot be set from a class
  function.
- `toEventually` needs a `DispatchTimeInterval`: `timeout: .seconds(5)`, not `5`.

## Pull requests

- Target the `develop` branch
- Keep the diff focused; unrelated cleanups are easier to review separately
- Document new public API with doc comments — they feed the generated DocC site
- Add a `CHANGELOG.md` entry under an *Unreleased* heading for anything
  user-visible

## License

Contributions are accepted under the [MIT license](../LICENSE) that covers this
project.
