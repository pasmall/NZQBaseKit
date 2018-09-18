//
//  NJStaticTableViewController.swift
//  NJKit
//
//  Created by HuXuPeng on 2018/9/8.
//

import UIKit

open class NJStaticTableViewController: NJTableViewController {
    public init() {
        super.init(tableViewStyle: UITableViewStyle.grouped)
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public var group: NJGroup = NJGroup()
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
}


// MARK:- datasource
extension NJStaticTableViewController {
    open func numberOfSections(in tableView: UITableView) -> Int {
        return group.sections.count
    }
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return group.sections[section].items.count
    }
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return group.sections[indexPath.section].items[indexPath.row].height
    }
    open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return group.sections[section].headerTitle
    }
    open func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return group.sections[section].footerTitle
    }
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCellSetting")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "UITableViewCellSetting")
        }
        let item = group.sections[indexPath.section].items[indexPath.row]
        cell!.textLabel?.text = item.title
        cell!.detailTextLabel?.text = item.subTitle
        cell!.accessoryType = item.operation == nil ? .none : .disclosureIndicator;
        let image = item.image
        
        if let img = image as? UIImage {
            cell!.imageView?.image = img
        }else if let url = image as? URL {
            cell!.imageView?.af_setImage(withURL: url)
        }else if let urlStr = image as? String {
            if let url = URL(string: urlStr) {
                cell!.imageView?.af_setImage(withURL: url)
            }
        }else {
            cell!.imageView?.image = nil;
        }
        
        return cell!
    }
}

// MARK:- delegate
extension NJStaticTableViewController {
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = group.sections[indexPath.section].items[indexPath.row]
        item.operation?(indexPath, group)
    }
}

extension NJStaticTableViewController {
    public var add: (_ item: NJItem) -> NJStaticTableViewController? {
        if group.sections.first == nil {
            group.sections.append(NJSection(headerTitle: nil, footerTitle: nil))
        }
        let add = {[weak self] (item: NJItem) -> NJStaticTableViewController? in
            self?.group.sections[0].items.append(item)
            return self
        }
        return add
    }
}






