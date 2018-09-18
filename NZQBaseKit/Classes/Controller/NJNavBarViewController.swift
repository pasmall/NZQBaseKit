//
//  NJNavBarViewController.swift
//  NJSwiftTodayNews
//
//  Created by HuXuPeng on 2018/5/15.
//  Copyright © 2018年 njhu. All rights reserved.
//

import UIKit

open  class NJNavBarViewController: UIViewController {
    // 默认可以全局滑动返回
    public var nj_interactivePopDisabled = false
    // 是否需要隐藏返回按钮
    public var nj_isBackActionBtnHidden = false {
        willSet {
            nj_backBtn.isHidden = newValue
        }
    }
    public let nj_navigationBar: NJNavigationBar = NJNavigationBar(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.main.bounds.width, height: UIApplication.shared.statusBarFrame.size.height + 44)))
    private let nj_backBtn: UIButton = UIButton(type: UIButtonType.custom)
    private var heightConstraint: NSLayoutConstraint?
    override open func viewDidLoad() {
        super.viewDidLoad()
        nj_addNavBar()
        nj_addBackBtn()
        navigationItem.addObserver(self, forKeyPath: "title", options: NSKeyValueObservingOptions.new, context: nil)
    }
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nj_backBtn.isHidden = nj_isBackActionBtnHidden
    }
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.bringSubview(toFront: nj_navigationBar)
        self.heightConstraint?.constant = UIApplication.shared.statusBarFrame.size.height + 44
    }
    
    deinit {
        if self.isViewLoaded {
            navigationItem.removeObserver(self, forKeyPath: "title")
        }
    }
}

// MARK:- StatusBar
//        setNeedsStatusBarAppearanceUpdate()
extension NJNavBarViewController {
   open override var prefersStatusBarHidden: Bool {
        return false
    }
   open  override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
   open  override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
    open override var shouldAutorotate: Bool {
        return false
    }
    // MARK: - about keyboard orientation
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//      return UIInterfaceOrientationMask.allButUpsideDown
        return UIInterfaceOrientationMask.portrait
    }
    //返回最优先显示的屏幕方向
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }
}

// MARK:- title
extension NJNavBarViewController {
    open override var title: String? {
        didSet {
            if isViewLoaded {
                nj_navigationBar.titleLabel.text = title
            }
        }
    }
   open  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let navigationItem = object as? UINavigationItem
        if keyPath! == "title" && (navigationItem != nil) && (navigationItem! == self.navigationItem) {
            nj_navigationBar.titleLabel.text = change?[NSKeyValueChangeKey.newKey] as? String
        }else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}

extension NJNavBarViewController {
    private func nj_addNavBar () {

        view.addSubview(nj_navigationBar)
        nj_navigationBar.isHidden = !(parent != nil && parent!.isKind(of: NJNavigationController.self))
        nj_navigationBar.titleLabel.text = navigationItem.title ?? title
        nj_navigationBar.translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = NSLayoutConstraint(item: nj_navigationBar, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 0, constant: 44.0 + UIApplication.shared.statusBarFrame.size.height)
        nj_navigationBar.addConstraint(heightConstraint)
        self.heightConstraint = heightConstraint
        view.addConstraint(NSLayoutConstraint(item: nj_navigationBar, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: nj_navigationBar, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: nj_navigationBar, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0))
    }
    private func nj_addBackBtn() {
        nj_backBtn.setImage(UIImage.nj_image(name: "NJKit_navigation_Button_Return_Normal", bundleClass: NJNavBarViewController.self), for: UIControlState.normal)
        nj_backBtn.setImage(UIImage.nj_image(name: "NJKit_navigation_Button_Return_Click", bundleClass: NJNavBarViewController.self), for: UIControlState.highlighted)
        nj_backBtn.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.size.height, width: 34.0, height: 44.0)
        nj_navigationBar.addSubview(nj_backBtn)
        nj_backBtn.addTarget(self, action: #selector(nj_backBtnClick(btn:)), for: UIControlEvents.touchUpInside)
    }
    @objc open func nj_backBtnClick(btn: UIButton) {
        if (navigationController?.presentedViewController != nil || navigationController?.presentingViewController != nil) && navigationController?.childViewControllers.count == 1 {
            dismiss(animated: true, completion: nil)
        }else if let navVc = navigationController {
            if navVc.childViewControllers.count > 1 {
                navVc.popViewController(animated: true)
            }
        }else if (presentationController != nil || presentedViewController != nil) {
            dismiss(animated: true, completion: nil)
        }
    }
}


