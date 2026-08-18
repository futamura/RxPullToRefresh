## Summary

<!-- What this changes, and why. Link the issue it closes, if there is one. -->

## Checklist

- [ ] Unit tests pass (`-only-testing:RxPullToRefreshTests`)
- [ ] `swiftlint lint --strict` reports no violations
- [ ] The example app builds
- [ ] UI tests pass, if this touches scroll handling or the example app
- [ ] Public API changes carry doc comments, and `CHANGELOG.md` has an entry

<!--
UI tests take roughly 15 minutes and only run on master, so run them locally when
your change affects scrolling behaviour:

xcodebuild test -project RxPullToRefresh.xcodeproj -scheme RxPullToRefresh \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  -only-testing:RxPullToRefreshUITests -derivedDataPath DerivedData
-->
