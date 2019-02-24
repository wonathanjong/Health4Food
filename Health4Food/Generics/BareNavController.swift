//
//  BareNavController.swift
//  Warp
//
//  Created by Kesi Maduka on 11/24/15.
//  Copyright © 2015 Storm Edge Apps LLC. All rights reserved.
//

import UIKit

class BareNavController: UINavigationController, UIScrollViewDelegate, UINavigationControllerDelegate {
    var segmentScrollView: UIScrollView?
    var currentIndicatorConstraint: NSLayoutConstraint?
    var extendedView: UIView?
    var customView: UIView?
    var segmentColor = UIColor.white

    class func controller(root: UIViewController) -> BareNavController {
        let x = BareNavController(navigationBarClass: RMNavigationBar.self, toolbarClass: nil)
        x.setViewControllers([root], animated: false)
        return x
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self

        //Edit NavBar
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = UIColor.white
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.red]
        self.navigationBar.setBackgroundImage(imageLayerForGradientBackground(), for: .default)
        self.navigationBar.shadowImage = UIImage()

        interactivePopGestureRecognizer?.delegate = nil
    }

    //MARK: Styling
    func imageLayerForGradientBackground() -> UIImage {
        var updatedFrame = self.navigationBar.bounds
        updatedFrame.size.height += 20

        let layer1 = CALayer()
        layer1.frame = updatedFrame
        layer1.backgroundColor = Constants.Colors.mainBlue.cgColor

        UIGraphicsBeginImageContext(CGSize(width: updatedFrame.width, height: updatedFrame.height))
        layer1.render(in: UIGraphicsGetCurrentContext()!)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    //MARK: Action
    func toggleSegmentControl(show: Bool) {
        if let navBar = self.navigationBar as? RMNavigationBar {
            navBar.segmentControlVisible = show
            navBar.layoutIfNeeded()
        }
    }

    func setExtendedSize(enabled: Bool, viewx: UIView?, animated: Bool = false) {
        if let navBar = self.navigationBar as? RMNavigationBar {
            if let viewx = viewx {
                navBar.setExtendedView(view: viewx)
                extendedView = viewx
            }
        }
        if animated {
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.innerSetExtendedSize(enabled: enabled, viewx: viewx)
            })
        } else {
            UIView.performWithoutAnimation { () -> Void in
                self.innerSetExtendedSize(enabled: enabled, viewx: viewx)
            }
        }
    }

    private func innerSetExtendedSize(enabled: Bool, viewx: UIView?) {
        if let navBar = self.navigationBar as? RMNavigationBar {
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                navBar.setExtendedSize(enabled: enabled)
                navBar.extendedViewHolder.alpha = CGFloat(enabled ? 1.0 : 0)
                navBar.layoutSubviews()
            })

            if let viewx = viewx {
                navBar.extendedViewHolder.addSubview(viewx)
                viewx.frame = navBar.extendedViewHolder.bounds
                extendedView = viewx
            }

            self.view.autoresizesSubviews = true

//            if let top = self.topViewController {
//                top.view.frame.origin.y = navBar.frame.size.height + statusBarHeight()
//                top.view.frame.size.height = self.view.frame.size.height - (navBar.frame.size.height + statusBarHeight())
//            }

        }
    }

    func setCustomTitleView(controller: UIViewController, title: String? = "", view: UIView? = nil, alignmentTop: Int? = 0) {
        if customView == view && customView != nil && customView!.alpha == 1.0 {
            return
        }

        if let view = view {
            customView = view
            view.isUserInteractionEnabled = false
            self.navigationBar.addSubview(view)
            controller.navigationItem.title = ""
            view.autoPinEdge(toSuperviewEdge: .left)
            view.autoPinEdge(toSuperviewEdge: .right)
            view.autoAlignAxis(toSuperviewAxis: .vertical)
            view.autoAlignAxis(toSuperviewAxis: .horizontal)
            self.navigationBar.layoutIfNeeded()
            view.alpha = 0.0
            UIView.animate(withDuration: 0.4, animations: { () -> Void in
                view.alpha = 1.0
                self.navigationBar.layoutIfNeeded()
            })
        } else {
            controller.navigationItem.title = title
            customView?.alpha = 0.0
        }
    }


    func setSegmentTitles(titles: [String]?, scrollView: UIScrollView?) {
        if let bar = self.navigationBar as? RMNavigationBar {
            segmentScrollView?.delegate = nil
            bar.segmentBarHolderView.subviews.forEach({ $0.removeFromSuperview() })

            guard let titles = titles else {
                return
            }

            guard let scrollView = scrollView else {
                return
            }

            var buttons = [UIButton]()

            var index = 0
            if scrollView.frame.size.width > 0 {
                index = Int(floorf(Float(scrollView.contentOffset.x/scrollView.frame.size.width)))
            }

            for i in 0 ..< titles.count {
                let button = UIButton()
                button.setTitle(titles[i], for: .normal)
                button.setTitleColor(UIColor(white: 255, alpha: 200/255), for: .normal)
                button.setTitleColor(UIColor.white, for: .selected)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
                button.tag = i
                button.addTarget(self, action: #selector(didClickSegmentButton), for: .touchUpInside)
                bar.segmentBarHolderView.addSubview(button)
                button.autoPinEdge(toSuperviewEdge: .top)
                button.autoPinEdge(toSuperviewEdge: .bottom)

                if i == 0 {
                    button.autoPinEdge(toSuperviewEdge: .left)

                    //Create Indicator
                    let indicatorView = UIView()
                    bar.segmentBarHolderView.addSubview(indicatorView)
                    indicatorView.backgroundColor = segmentColor
                    indicatorView.autoMatch(.width, to: .width, of: button)
                    indicatorView.autoSetDimension(.height, toSize: 4)
                    indicatorView.autoPinEdge(toSuperviewEdge: .bottom)
                    indicatorView.tag = -1
                    currentIndicatorConstraint = indicatorView.autoPinEdge(toSuperviewEdge: .left)

                    //Create Bottom Bar
                    let bottomBarLine = UIView()
                    bar.segmentBarHolderView.addSubview(bottomBarLine)
                    bottomBarLine.backgroundColor = indicatorView.backgroundColor
                    bottomBarLine.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero, excludingEdge: .top)
                    bottomBarLine.autoSetDimension(.height, toSize: 1)
                    bottomBarLine.tag = -1
                } else {
                    let lastButton = buttons[i-1]
                    button.autoPinEdge(.left, to: .right, of: lastButton)
                    button.autoMatch(.width, to: .width, of: lastButton)
                }

                if i == (titles.count - 1) {
                    button.autoPinEdge(toSuperviewEdge: .right)
                }

                buttons.append(button)
            }

            if index != 0 {
                currentIndicatorConstraint?.constant = scrollView.contentOffset.x/scrollView.contentSize.width*scrollView.frame.width
            }
            scrollView.delegate = self
            segmentScrollView = scrollView
        }
    }

    @objc func didClickSegmentButton(button: UIButton) {
        setActiveNavIndex(index: button.tag)
    }

    func setActiveNavIndex(index: Int) {
        if let bar = self.navigationBar as? RMNavigationBar {
            for i in 0 ..< bar.segmentBarHolderView.subviews.count {
                if let button = bar.segmentBarHolderView.subviews[i] as? UIButton {
                    if button.tag == index {
                        button.isSelected = true
                        DispatchQueue.main.async {
                            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                                self.segmentScrollView!.contentOffset.x = CGFloat(index)*self.segmentScrollView!.frame.size.width
                            })
                        }
                    } else {
                        button.isSelected = false
                    }
                }
            }
        }
    }

    // MARK: UIScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let bar = self.navigationBar as? RMNavigationBar {
            let constant = (scrollView.contentOffset.x/scrollView.contentSize.width)*(bar.segmentBarHolderView.frame.width)
            if constant.isFinite {
                currentIndicatorConstraint?.constant = constant
                bar.segmentBarHolderView.layoutIfNeeded()
            }
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let bar = self.navigationBar as? RMNavigationBar {
            let index = Int(floorf(Float(scrollView.contentOffset.x/scrollView.frame.size.width)))

            for i in 0 ..< bar.segmentBarHolderView.subviews.count {
                if let button = bar.segmentBarHolderView.subviews[i] as? UIButton {
                    button.isSelected = button.tag == index
                }
            }
        }
    }

    //MARK: Back Button

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.interactivePopGestureRecognizer != nil {
            self.interactivePopGestureRecognizer!.isEnabled  = true
        }
        super.pushViewController(viewController, animated: animated)
    }

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if self.viewControllers.index(of: viewController)! != NSNotFound && self.viewControllers.index(of: viewController)! > 0 {
            viewController.navigationItem.hidesBackButton = true
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backBT"), style: .plain, target: self, action: #selector(BareNavController.popCurrentViewController))
        }

        UIView.performWithoutAnimation { () -> Void in
            if let navBar = self.navigationBar as? RMNavigationBar {
                navBar.layoutSubviews(topItem: viewController.navigationItem)
            }

            self.view.layoutSubviews()
            viewController.view.layoutSubviews()
        }
    }

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        self.interactivePopGestureRecognizer!.isEnabled  = true

        UIView.performWithoutAnimation { () -> Void in
            if let navBar = self.navigationBar as? RMNavigationBar {
                navBar.layoutSubviews(topItem: viewController.navigationItem)
            }

            self.view.layoutSubviews()
            viewController.view.layoutSubviews()
        }
    }

    @objc func popCurrentViewController() {
        self.popViewController(animated: true)
        self.view.superview?.layoutSubviews()
    }
}

class RMNavigationBar: UINavigationBar {
    var initialHeight = CGFloat(52)
    var extendedHeight = CGFloat(175)
    var startsAtOrigin = false
    var extended = false

    var imageView = UIImageView()

    var extendedViewCon: NSLayoutConstraint?
    var extendedViewHolder = UIView()
    let segmentBarHolderView = UIView()

    var segmentControlVisible = false {
        didSet {
            if segmentBarHolderView.superview == nil {
                self.addSubview(segmentBarHolderView)

                segmentBarHolderView.autoSetDimension(.height, toSize: 30)
                segmentBarHolderView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero, excludingEdge: .top)
            }
            self.frame.size = sizeThatFits(CGSize.zero)
        }
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: getHeight() + (segmentControlVisible ? 19: 0))
    }

    override func layoutSubviews() {
        if let item = self.topItem {
            layoutSubviews(topItem: item)
        }
    }

    func layoutSubviews(topItem: UINavigationItem) {

        super.layoutSubviews()
        var btPosition = CGFloat(-3.0)
        var titlePosition = CGFloat(-5.0)
        if segmentControlVisible {
            btPosition -= 20.0
            titlePosition -= 20.0
        }

        btPosition -= (getHeight() - 52.0)
        titlePosition -= (getHeight() - 52.0)

        if let leftItems = topItem.leftBarButtonItems {
            for item in leftItems {
                item.setBackgroundVerticalPositionAdjustment(btPosition, for: .default)
            }
        }

        if let rightItems = topItem.rightBarButtonItems {
            for item in rightItems {
                item.setBackgroundVerticalPositionAdjustment(btPosition, for: .default)
            }
        }

        self.topItem?.backBarButtonItem = nil

        self.setTitleVerticalPositionAdjustment(titlePosition, for: .default)

        extendedViewHolder.frame.origin.x = 0
        extendedViewHolder.frame.origin.y = startsAtOrigin ? -statusBarHeight() : 36
        extendedViewHolder.frame.size.width = self.frame.width
        self.insertSubview(extendedViewHolder, at: 1)

        self.insertSubview(imageView, at: 1)
        imageView.autoPinEdgesToSuperviewEdges()
        imageView.contentMode = .top
        imageView.clipsToBounds = true

    }

    func getHeight() -> CGFloat {
        return extended ? extendedHeight : initialHeight
    }

    func setExtendedView(view: UIView) {
        extendedViewHolder.subviews.forEach({ $0.removeFromSuperview() })

        extendedViewHolder.addSubview(view)
        view.frame = extendedViewHolder.bounds
        view.layoutSubviews()
    }

    func setExtendedSize(enabled: Bool) {
        if extendedViewHolder.superview == nil {
            extendedViewHolder.clipsToBounds = true

            self.isUserInteractionEnabled = true
            extendedViewHolder.isUserInteractionEnabled = true
        }

        extended = enabled
        self.frame.size = sizeThatFits(CGSize.zero)
        self.layoutSubviews()

        if enabled {
            extendedViewHolder.frame.size.height = sizeThatFits(CGSize.zero).height - (startsAtOrigin ? -statusBarHeight() : 36)
            extendedViewHolder.alpha = 1.0
        } else {
            extendedViewHolder.frame.size.height = 0
            extendedViewHolder.alpha = 0.0
        }
    }
}

func statusBarHeight() -> CGFloat {
    let statusBarSize = UIApplication.shared.statusBarFrame.size
    return Swift.min(statusBarSize.width, statusBarSize.height)
}
