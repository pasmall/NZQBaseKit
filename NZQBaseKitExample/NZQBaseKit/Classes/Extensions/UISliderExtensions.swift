//
//  UISliderExtensions.swift
//  EZSwiftExtensions
//
//  Created by Lyric on 3/1/16.
//  Copyright © 2016 Lyric. All rights reserved.
//

#if os(iOS)

import UIKit

extension UISlider {
    ///EZSE: Slider moving to value with animation duration
    public func setValue(_ value: Float, duration: Double) {
      UIView.animate(withDuration: duration, animations: { () -> Void in
        self.setValue(self.value, animated: true)
        }, completion: { (_) -> Void in
          UIView.animate(withDuration: duration, animations: { () -> Void in
            self.setValue(value, animated: true)
            }, completion: nil)
      })
    }
}

#endif
