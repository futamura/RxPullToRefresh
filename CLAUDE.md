# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

RxPullToRefresh — RxSwift ベースの pull-to-refresh ライブラリ (iOS 13+, Swift 5.9+, RxSwift 6)。配布は SPM のみ (CocoaPods/Carthage は v2.0.0 で廃止)。

## Commands

シミュレータ名・ID は環境依存。`xcrun simctl list devices available` で確認して差し替える。

```bash
# 単体テスト (Quick/Nimble、シミュレータ必須)
xcodebuild test -project RxPullToRefresh.xcodeproj -scheme RxPullToRefresh \
  -destination 'platform=iOS Simulator,name=iPhone 16' -only-testing:RxPullToRefreshTests

# 単一 spec クラスのみ
xcodebuild test ... -only-testing:RxPullToRefreshTests/AnimatorSpec

# UI テスト (Example アプリ起動、重い)
xcodebuild test -project RxPullToRefresh.xcodeproj -scheme RxPullToRefresh \
  -destination '...' -only-testing:RxPullToRefreshUITests

# framework / Example ビルド
xcodebuild build -project RxPullToRefresh.xcodeproj -scheme RxPullToRefresh -destination 'generic/platform=iOS Simulator'
xcodebuild build -project RxPullToRefresh.xcodeproj -scheme RxPullToRefreshExample -destination 'generic/platform=iOS Simulator'

# Lint
swiftlint lint

# DocC (CI が master push で GitHub Pages へデプロイ)
xcodebuild docbuild -project RxPullToRefresh.xcodeproj -scheme RxPullToRefresh -destination 'generic/platform=iOS Simulator'
```

## Build system の二重構成

- `Package.swift` = ライブラリ配布用 (target は `Sources/` のみ)。ルートに xcodeproj が同居するため、この dir での `xcodebuild -scheme` は xcodeproj を拾う。SPM 側の検証はローカルパス依存の消費側パッケージを別 dir に作って行う
- `RxPullToRefresh.xcodeproj` = 開発用。4 target (framework / Tests / Example / UITests)。依存は SPM package reference (RxSwift, Quick, Nimble, RxDataSources)。pbxproj は手編集されている — package 追加時は XCRemoteSwiftPackageReference / XCSwiftPackageProductDependency / packageProductDependencies / PBXBuildFile(productRef) の 4 箇所をセットで触る

## Architecture

- コア `RxPullToRefresh` クラスは機能別に extension 分割: `+Core.swift` (KVO 監視・スクロール処理)、`+Refreshing.swift` (状態遷移)、`+Rx.swift` (Reactive extension)
- UIScrollView への公開 API は `p2r` 名前空間経由 (`UIScrollView+P2R.swift` の `RxPullToRefreshProxy`)
- Rx 連携は 2 系統: KVO (`observeWeakly`) ベースの ControlProperty/Driver 群と、`RxPullToRefreshDelegate` を `DelegateProxy` (RxCocoa) でラップした `rx.action`
- `RxPullToRefreshView` はユーザーがサブクラス化する表示コンポーネント。`action(state:progress:scroll:)` の override 必須 (基底実装は fatalError)
- UITests target はアプリ本体をリンクせず Example のソースを再コンパイルして `@testable import RxPullToRefreshExample` する方式。Example のビルド設定変更時は UITests too

## Tests

- Quick 7 形式: `override class func spec()` (instance spec() は Quick 6+ で廃止)。`self.continueAfterFailure` は class func 内で使用不可
- Nimble 13: `toEventually(..., timeout: .seconds(N))` — 数値リテラル不可
- UITests は 1 ケース 40〜60 秒 × 17 = 約 14 分。`-derivedDataPath` を明示しないと外部の Xcode 操作で成果物が消え `Cannot launch simulated executable` になる
- Example は `UITableViewController` + storyboard outlet で delegate が二重配線される。`rx.setDelegate` の前に `delegate`/`dataSource` を nil にしないと RxCocoa の assert で落ちる (Debug ビルドのみ発火)

## CI (.github/workflows/)

- `ci.yml`: push/PR (master, develop) で unit tests + Example build + SwiftLint。UI tests は master push と `workflow_dispatch` のみ (所要 15 分)
- `docs.yml`: master push で DocC → GitHub Pages (Pages source を「GitHub Actions」に切り替えてある前提)
- `release.yml`: `2.0.0` 形式のタグ push で CHANGELOG の該当セクションを抽出して GitHub Release を作成
- SwiftLint は macOS runner に同梱されないため ubuntu + `ghcr.io/realm/swiftlint` コンテナで実行する
