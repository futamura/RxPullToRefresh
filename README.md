[![CI](https://github.com/futamura/RxPullToRefresh/actions/workflows/ci.yml/badge.svg)](https://github.com/futamura/RxPullToRefresh/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/futamura/RxPullToRefresh/branch/master/graph/badge.svg)](https://codecov.io/gh/futamura/RxPullToRefresh)
[![Swift Package Manager compatible](https://img.shields.io/badge/SPM-compatible-4BC51D.svg)](https://swift.org/package-manager/)
![Platform](https://img.shields.io/badge/Platform-iOS%2013%2B-blue.svg)
![Language](https://img.shields.io/badge/Language-Swift%205.9-orange.svg)
![License](https://img.shields.io/badge/License-MIT-lightgrey.svg)

# RxPullToRefresh

A Swift library allows you to create a flexibly customizable pull-to-refresh view supporting RxSwift.

<img src="https://raw.githubusercontent.com/futamura/RxPullToRefresh/master/Metadata/screenshot-animation.gif" alt="drawing" width="240px" style="width:240px;"/>

## Features

- Support UIScrollView, UITableView, and UICollectionView
- Customizable refresh view
- Customizable animaton options
- Configurable option whether to load while dragging or to load after an user release a finger
- Error handling
- Support RxSwift/RxCocoa

## Requirements

- iOS 13.0 or later
- Swift 5.9 or later
- RxSwift 6.x

Upgrading from 1.x? See the [migration guide](CHANGELOG.md#migration-guide) — 2.0.0
drops CocoaPods and Carthage in favour of Swift Package Manager.

## Installation

### Swift Package Manager

In Xcode, select **File > Add Package Dependencies…** and enter:

```
https://github.com/futamura/RxPullToRefresh.git
```

Or add the following to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/futamura/RxPullToRefresh.git", from: "2.0.0")
]
```

## Usage

Read the [API reference](https://futamura.github.io/RxPullToRefresh/documentation/rxpulltorefresh/) for detailed information.

### Basic Usage

#### Import frameworks to your project

```swift
import RxSwift
import RxCocoa
import RxPullToRefresh
```

#### Add RxPullToRefresh

Create a RxPullToRefresh object.

```swift
// Create a RxPullToRefresh object
self.topPullToRefresh = RxPullToRefresh(position: .top)
// Add a RxPullToRefresh object to UITableView
self.tableView.p2r.addPullToRefresh(self.topPullToRefresh)
```

#### Observe RxPullToRefreshDelegate

By observing [RxPullToRefreshDelegate](https://futamura.github.io/RxPullToRefresh/documentation/rxpulltorefresh/rxpulltorefreshdelegate/), you can watch the state of a RxPullToRefresh object. This delegate is get called by the RxPullToRefresh object every time its [state](https://futamura.github.io/RxPullToRefresh/documentation/rxpulltorefresh/rxpulltorefreshstate/) or scrolling rate is changed.
```swift
// Observe RxPullToRefreshDelegate
self.topPullToRefresh.rx.action
        .subscribe(onNext: { [weak self] (state: RxPullToRefreshState, progress: CGFloat, scroll: CGFloat) in
            // Send request if RxPullToRefreshState is changed to .loading
            switch state {
            case .loading: self?.prepend()
            default:       break
            }
        })
        .disposed(by: self.disposeBag)
```

You can also conform to the delegate directly and assign it to `delegate`. The
protocol refines `NSObjectProtocol`, so the conforming type has to inherit from
`NSObject` — a plain Swift class does not compile.
```swift
final class ViewController: UIViewController, RxPullToRefreshDelegate {
    func action(state: RxPullToRefreshState, progress: CGFloat, scroll: CGFloat) {
        switch state {
        case .loading: self.prepend()
        default:       break
        }
    }
}

self.topPullToRefresh.delegate = self
```

#### Load and append contents

```swift
self.viewModel.prepend()
              .subscribe(onSuccess: { [weak self] in
                  // Successfully loaded, collapse refresh view immediately
                  self?.tableView.p2r.endRefreshing(at: .top)
              }, onError: { [weak self] (_: Error) in
                  // Failed to load, show error
                  self?.tableView.p2r.failRefreshing(at: .top)
              })
              .disposed(by: self.disposeBag)
```

#### Disable refreshing by binding Boolean value to canLoadMore property

```swift
self.viewModel.canPrepend
        .asDriver()
        .drive(self.topPullToRefresh.rx.canLoadMore)
        .disposed(by: self.disposeBag)
```

#### Dispose RxPullToRefresh objects

```swift
override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.tableView.p2r.endAllRefreshing()
    self.tableView.p2r.removeAllPullToRefresh()
}
```

### Advanced Usage

#### About the example project

`RxPullToRefresh` allows you flexibly customize a refresh view by inheriting [RxPullToRefresh](https://futamura.github.io/RxPullToRefresh/documentation/rxpulltorefresh/rxpulltorefresh/) and [RxPullToRefreshView](https://futamura.github.io/RxPullToRefresh/documentation/rxpulltorefresh/rxpulltorefreshview/) classes. Please check [example sources](https://github.com/futamura/RxPullToRefresh/blob/master/Example/) for advanced usage.

- [CustomRefresh](https://github.com/futamura/RxPullToRefresh/blob/master/Example/CustomRefresh.swift): A class inheriting from `RxPullToRefresh`.
- [CustomRefreshView](https://github.com/futamura/RxPullToRefresh/blob/master/Example/CustomRefresh.swift): A class inheriting from `RxPullToRefreshView`. Animation logics are implemented in this class.
- [BaseTableViewController](https://github.com/futamura/RxPullToRefresh/blob/master/Example/TableViewController.swift): A view controller that conforms to MVVM architecture.
- [CustomTableViewController](https://github.com/futamura/RxPullToRefresh/blob/master/Example/TableViewController.swift): A view controller that creates a `CustomPullToRefresh` instance.
- [TableViewModel](https://github.com/futamura/RxPullToRefresh/blob/master/Example/TableViewModel.swift): A view model that manipulates data sources.

#### Build the example app

1. Open `RxPullToRefresh.xcodeproj` (dependencies are resolved automatically by Swift Package Manager)
2. Select the scheme `RxPullToRefreshExample` from the drop-down menu in the upper left of the Xcode window
3. Press ⌘R

## Contributing

Bug reports and pull requests are welcome. See [CONTRIBUTING.md](.github/CONTRIBUTING.md)
for how to build the project and run the checks, and [SECURITY.md](.github/SECURITY.md)
for how to report a vulnerability privately.

## Copyright

RxPullToRefresh is released under MIT license, which means you can modify it, redistribute it or use it however you like.
