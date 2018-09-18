//
//  NJSection.swift
//  NJKit
//
//  Created by HuXuPeng on 2018/9/8.
//

import Foundation

public struct NJItem {
   public var image: Any?
   public var title: String?
   public var subTitle: String?
   public var height: CGFloat = 50
   public var operation: ((_ indexPath: IndexPath, _ gropu: NJGroup) -> ())?
   public init(image: Any? = nil, title: String?, subTitle: String? = nil, height: CGFloat = 50, operation: ((_ indexPath: IndexPath, _ gropu: NJGroup) -> ())? = nil) {
        self.image = image
        self.title = title
        self.subTitle = subTitle
        self.height = height
        self.operation = operation
    }
}

public struct NJSection {
   public var headerTitle: String?
   public var footerTitle: String?
   public var items: [NJItem] = [NJItem]()
   public init(headerTitle: String?, footerTitle: String?) {
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
    }
}

public struct NJGroup {
   public var sections: [NJSection] = [NJSection]()
}
