//
//  Foundation+Extension.swift
//  NJKit
//
//  Created by HuXuPeng on 2018/7/22.
//

import Foundation


public extension String {
    
    public func urlEncoding() -> String? {
        let characters = "`#%^{}\"[]|\\<> "
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.init(charactersIn: characters).inverted)
    }
}


public extension Bundle {
    public static func nj_curBundle(class bundleOfClass: AnyClass?, bundleFile: String? = nil) -> Bundle {
        
        var bundle = bundleOfClass == nil ? Bundle.main : Bundle(for: bundleOfClass!)
        
        if let path = bundle.path(forResource: bundleFile, ofType: "bundle") {
            if let newBundle = Bundle.init(path: path) {
                bundle = newBundle
            }
        }
        
        return bundle
    }
}
