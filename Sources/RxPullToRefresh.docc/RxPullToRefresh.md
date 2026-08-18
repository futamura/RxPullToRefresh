# ``RxPullToRefresh``

Build a customizable pull-to-refresh view driven by RxSwift.

## Overview

Attach a ``RxPullToRefresh`` object to any scroll view through the `p2r`
namespace, observe its state through `rx.action`, and end refreshing when your
request finishes. A refresh view can sit at the top, the bottom, or both.

```swift
topPullToRefresh = RxPullToRefresh(position: .top)
tableView.p2r.addPullToRefresh(topPullToRefresh)

topPullToRefresh.rx.action
        .subscribe(onNext: { [weak self] (state: RxPullToRefreshState, _: CGFloat, _: CGFloat) in
            if case .loading = state { self?.prepend() }
        })
        .disposed(by: disposeBag)
```

Refreshing never ends on its own — call `endRefreshing(at:)` when the request
succeeds and `failRefreshing(at:)` when it fails.

To customize the appearance, subclass ``RxPullToRefreshView`` and override
`action(state:progress:scroll:)`. The example app pairs that with a
``RxPullToRefresh`` subclass to drive its own animation.

## Topics

### Attaching to a scroll view

- ``RxPullToRefresh``
- ``RxPullToRefreshProxy``
- ``RxPullToRefreshCompatible``

### Reacting to state changes

- ``RxPullToRefreshState``
- ``RxPullToRefreshDelegate``

### Customizing the refresh view

- ``RxPullToRefreshView``
- ``RxPullToRefreshPosition``
- ``RxPullToRefreshAnimationType``
