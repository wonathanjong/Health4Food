//
//  Window.swift
//  Dawgtown
//
//  Created by Kesi Maduka on 10/2/15.
//  Copyright © 2015 Storm Edge Apps LLC. All rights reserved.
//

import UIKit
import PureLayout

class Window: UIWindow {
    var hasHidden = false
    let splashView = UIView()
    var screenIsReady = false

    override func addSubview(_ view: UIView) {
        if !hasHidden {
            self.insertSubview(view, belowSubview: splashView)
        } else {
            super.addSubview(view)
        }
    }

    override func makeKeyAndVisible() {
        showSplash()
        super.makeKeyAndVisible()
    }

    func showSplash() {
        let imageView = UIImageView(image: UIImage(named: "whiteLogo"))
        imageView.contentMode = .scaleAspectFit

        self.backgroundColor = UIColor.white
        self.splashView.backgroundColor = Constants.Colors.mainBlue

        self.splashView.addSubview(imageView)
        imageView.autoAlignAxis(toSuperviewAxis: .vertical)
        imageView.autoAlignAxis(toSuperviewAxis: .horizontal)
        imageView.autoSetDimensions(to: CGSize(width: 100, height: 100))

        self.addSubview(self.splashView)
        self.splashView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero)

        DispatchQueue.global(qos: .userInitiated).async {
            while(!self.screenIsReady) {
                RunLoop.current.run(mode: RunLoop.Mode.default, before: NSDate.distantFuture)
            }

            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                    self.splashView.alpha = 0.0
                    self.splashView.transform = CGAffineTransform(scaleX: 4.0, y: 4.0)
                    }) { (complete) -> Void in
                        self.splashView.removeFromSuperview()
                        self.hasHidden = true
                }
            }
        }
    }
}
