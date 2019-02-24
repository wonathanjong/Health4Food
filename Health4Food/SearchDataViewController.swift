//
//  SearchData.swift
//  Health4Food
//
//  Created by Jonathan Wong  on 2/24/19.
//  Copyright © 2019 Jonathan Wong . All rights reserved.
//

import Foundation
import UIKit
import PureLayout
import BarcodeScanner

class SearchDataViewController: UITableViewController{
    override func viewDidLoad() {
        navigationItem.title = "HEALTH4FOOD"
        if let window = AppDelegate.del().window as? Window {
            window.screenIsReady = true
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)]
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }
}
