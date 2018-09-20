//
//  UISwitchExtensions.swift
//  EZSwiftExtensions
//
//  Created by Lyric on 4/22/16.
//  Copyright © 2016 Lyric. All rights reserved.
//

#if os(iOS)

import UIKit

extension UISwitch {

	/// EZSE: toggles Switch
	public func toggle() {
		self.setOn(!self.isOn, animated: true)
	}
}

#endif
