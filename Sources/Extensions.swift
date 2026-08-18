//
//  Extensions.swift
//  RxPullToRefresh
//
//  Created by kojirof on 2019/01/06.
//  Copyright © 2019 Kojiro Futamura. All rights reserved.
//

import Foundation

/**
 RxPullToRefresh extension for UIScrollView.
 */
public struct RxPullToRefreshProxy<Base> {
    /** Base object to extend. */
    public let base: Base

    /**
     Creates extensions with base object.

     - parameter base: Base object.
     */
    public init(_ base: Base) {
        self.base = base
    }
}

/** A type that has p2r extensions. */
public protocol RxPullToRefreshCompatible {
    /** Extended type */
    associatedtype CompatibleType

    /** RxPullToRefreshProxy extensions. */
    static var p2r: RxPullToRefreshProxy<CompatibleType>.Type { get set }

    /** RxPullToRefreshProxy extensions. */
    var p2r: RxPullToRefreshProxy<CompatibleType> { get set }
}

// swiftlint:disable unused_setter_value
extension RxPullToRefreshCompatible {
    /* RxPullToRefreshProxy extensions. */
    public static var p2r: RxPullToRefreshProxy<Self>.Type {
        get { return RxPullToRefreshProxy<Self>.self }
        set { /* this enables using RxPullToRefreshProxy to "mutate" base type */ }
    }

    /* RxPullToRefreshProxy extensions. */
    public var p2r: RxPullToRefreshProxy<Self> {
        get { return RxPullToRefreshProxy(self) }
        set { /* this enables using RxPullToRefreshProxy to "mutate" base object */ }
    }
}
// swiftlint:enable unused_setter_value

/* Extend NSObject with `p2r` proxy. */
extension NSObject: RxPullToRefreshCompatible {
}
