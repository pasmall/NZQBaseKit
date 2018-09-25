//
//  NSObjectExtensions.swift
//  EZSwiftExtensions
//
//  Created by Lyric on 16/07/15.
//  Copyright (c) 2015 Lyric. All rights reserved.
//

#if os(iOS) || os(tvOS)
import Foundation

extension NSObject {
    public var className: String {
        return type(of: self).className
    }

    public static var className: String {
        return String(describing: self)
    }
}

#endif
