//
//  MiscSpec.swift
//  RxPullToRefreshTests
//
//  Created by kojirof on 2018/12/26.
//  Copyright © 2018 Kojiro Futamura. All rights reserved.
//

import Foundation

import Quick
import Nimble
import RxTest
import RxBlocking

@testable import RxPullToRefresh

class MiscSpec: QuickSpec {

    override class func spec() {
        describe("Spec Miscellaneous") {
            describe("Spec Codable") {
                it("DefaultRefreshView") {
                    let archiver: NSKeyedArchiver = NSKeyedArchiver(requiringSecureCoding: false)
                    archiver.finishEncoding()
                    let coder: NSKeyedUnarchiver = try NSKeyedUnarchiver(forReadingFrom: archiver.encodedData)
                    coder.requiresSecureCoding = false
                    let refreshView: DefaultRefreshView? = DefaultRefreshView(coder: coder)
                    expect(refreshView).notTo(beNil())
                }
            }
        }
    }

}
