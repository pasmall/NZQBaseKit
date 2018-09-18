//
//  NJNavigationController.swift
//  NJSwiftTodayNews
//
//  Created by HuXuPeng on 2018/5/15.
//  Copyright © 2018年 njhu. All rights reserved.
//

import UIKit

open class NJNavigationController: UINavigationController {

    open  override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isHidden = true
        view.backgroundColor = UIColor.groupTableViewBackground
//        getSystemGestureOfBack()
    }
    open  override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if childViewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    open  override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationBar.isHidden = true
    }
    open  override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationBar.isHidden = true
    }
}

// MARK:- gesture, 有问题
extension NJNavigationController: UIGestureRecognizerDelegate {
    private func getSystemGestureOfBack() {
        let panGes = UIPanGestureRecognizer(target: self.interactivePopGestureRecognizer?.delegate, action: Selector(("handleNavigationTransition:")))
        view.addGestureRecognizer(panGes)
        panGes.delegate = self
        self.interactivePopGestureRecognizer?.isEnabled = false
    }
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIPanGestureRecognizer) -> Bool {
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view)
        print(translation)
        if let vc = self.childViewControllers.last as? NJNavBarViewController {
            return (self.childViewControllers.count > 1 && !vc.nj_interactivePopDisabled)
        }else {
            return false
        }
    }
}

extension NJNavigationController {
    open override var prefersStatusBarHidden: Bool {
        return self.topViewController?.prefersStatusBarHidden ?? false
    }
    open  override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.topViewController?.preferredStatusBarStyle ?? UIStatusBarStyle.default
    }
    open  override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return self.topViewController?.preferredStatusBarUpdateAnimation ?? UIStatusBarAnimation.slide
    }
    open override var shouldAutorotate: Bool {
        return self.topViewController?.shouldAutorotate ?? false
    }
    // MARK: - about keyboard orientation
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.topViewController?.supportedInterfaceOrientations ?? UIInterfaceOrientationMask.allButUpsideDown;
    }
    //返回最优先显示的屏幕方向
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return self.topViewController?.preferredInterfaceOrientationForPresentation ?? UIInterfaceOrientation.portrait
    }
}
