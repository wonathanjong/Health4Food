//
//  AppDelegate.swift
//  Health4Food
//
//  Created by Jonathan Wong  on 2/21/19.
//  Copyright © 2019 Jonathan Wong . All rights reserved.
//

import UIKit
import Foundation
import IQKeyboardManagerSwift
import PureLayout

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        //Sets the window frame for the different iOS device
        self.window = Window(frame: UIScreen.main.bounds)
        
        self.window!.rootViewController = createTabSet()
        self.window?.makeKeyAndVisible()
        
        //Configure navigation bar appearance
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.tintColor = Constants.Colors.mainBlue
        navigationBarAppearance.barTintColor = UIColor.white
        navigationBarAppearance.titleTextAttributes = [kCTForegroundColorAttributeName: UIColor.white] as [NSAttributedString.Key : Any]
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func createTabSet() -> UITabBarController {
        let tabVC = UITabBarController()
        
        let collectDataVC = CollectDataViewController()
        let collectDataNC = BareNavController(rootViewController: collectDataVC)
        let collectDataTBI = UITabBarItem(title: "Collect Data", image: UIImage(named: "barcode"), selectedImage: UIImage(named: "barcode"))
        collectDataNC.tabBarItem = collectDataTBI
        //schedule tab for sellers
        let searchDataVC = SearchDataViewController()
        let searchDataNC = BareNavController(rootViewController: searchDataVC)
        let searchDataTBI = UITabBarItem(title: "Search", image: UIImage(named: "search"), selectedImage: UIImage(named: "search"))
        searchDataNC.tabBarItem = searchDataTBI
            
        tabVC.viewControllers = [collectDataNC, searchDataNC]
        tabVC.tabBar.tintColor = Constants.Colors.mainBlue
        
        return tabVC
    }
    func signIn() {
        if let window = window as? Window {
            let tabSet = createTabSet()
            
            UIView.transition(with: window, duration: window.screenIsReady ? 0.5 : 0.0, options: .transitionCrossDissolve, animations: { () -> Void in
                window.rootViewController = tabSet
            }, completion: { (finished) -> Void in
                
            })
        }
    }
    
    class func del() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

}

