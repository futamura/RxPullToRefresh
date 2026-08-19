//
//  RefreshingSpec.swift
//  RxPullToRefreshTests
//
//  Created by kojirof on 2026/08/19.
//  Copyright © 2026 Kojiro Futamura. All rights reserved.
//

import Foundation
import UIKit

import Quick
import Nimble

@testable import RxPullToRefresh

/* Every state change calls action(state:progress:scroll:), and the base
   implementation traps, so these specs need a view that answers instead. */
private class StubRefreshView: RxPullToRefreshView {

    private(set) var states: [RxPullToRefreshState] = [RxPullToRefreshState]()

    override func action(state: RxPullToRefreshState, progress: CGFloat, scroll: CGFloat) {
        self.states.append(state)
    }
}

class RefreshingSpec: QuickSpec {

    override class func spec() {
        /* endRefreshing() and failRefreshing() only reach backToInitialOffset()
           when they interrupt a pull that never turned into a load, so these
           specs stop at .pulling instead of going through .loading. */
        describe("Spec RxPullToRefresh interrupting a pull") {
            var scrollView: UIScrollView!
            var refreshView: StubRefreshView!
            var pullToRefresh: RxPullToRefresh!

            beforeEach {
                scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
                refreshView = StubRefreshView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
            }

            /* Drags the refresh view into view and then releases it, which is
               the state an app sees when it cancels a refresh the user started
               but the threshold was never crossed. */
            func pull(_ position: RxPullToRefreshPosition, to offsetY: CGFloat) {
                pullToRefresh = RxPullToRefresh(refreshView: refreshView, position: position)
                scrollView.p2r.addPullToRefresh(pullToRefresh)
                scrollView.contentSize = CGSize(width: 100, height: 200)
                expect(pullToRefresh.isEnabled).to(beTrue())

                pullToRefresh.isDragging = true
                scrollView.contentOffset = CGPoint(x: 0, y: offsetY)
                expect(pullToRefresh.state).to(equal(RxPullToRefreshState.pulling))
                pullToRefresh.isDragging = false
            }

            it("endRefreshing backs a top refresh to the initial offset") {
                /* -20 keeps the refresh view partly visible without reaching
                   the 44pt threshold that would start a load. */
                pull(.top, to: -20.0)

                pullToRefresh.endRefreshing()

                expect(pullToRefresh.state).to(equal(RxPullToRefreshState.backing))
                expect(refreshView.states).to(contain(RxPullToRefreshState.backing))
                expect(pullToRefresh.state).toEventually(equal(RxPullToRefreshState.initial), timeout: .seconds(30))
                expect(scrollView.contentOffset).toEventually(equal(CGPoint(x: 0, y: 0)), timeout: .seconds(30))
            }

            it("failRefreshing backs a bottom refresh to the initial offset") {
                /* The bottom refresh view starts where the content ends, so
                   100 is the resting offset and 120 is a 20pt pull past it. */
                pull(.bottom, to: 120.0)

                pullToRefresh.failRefreshing()

                expect(pullToRefresh.state).to(equal(RxPullToRefreshState.backing))
                expect(refreshView.states).to(contain(RxPullToRefreshState.backing))
                expect(pullToRefresh.state).toEventually(equal(RxPullToRefreshState.initial), timeout: .seconds(30))
                expect(scrollView.contentOffset).toEventually(equal(CGPoint(x: 0, y: 100)), timeout: .seconds(30))
            }
        }
    }
}
