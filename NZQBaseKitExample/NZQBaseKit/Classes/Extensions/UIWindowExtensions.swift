//
//  UIWindowExtensions.swift
//  EZSwiftExtensions
//
//  Created by Lyric on 3/1/16.
//  Copyright © 2016 Lyric. All rights reserved.
//

#if os(iOS) || os(tvOS)

import UIKit

extension UIWindow {
    /// EZSE: Creates and shows UIWindow. The size will show iPhone4 size until you add launch images with proper sizes. TODO: Add to readme
    public convenience init(viewController: UIViewController, backgroundColor: UIColor) {
        self.init(frame: UIScreen.main.bounds)
        self.rootViewController = viewController
        self.backgroundColor = backgroundColor
        self.makeKeyAndVisible()
    }
}

#endif
