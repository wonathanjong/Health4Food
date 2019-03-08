//
//  Constants.swift
//  SwipeMeIn
//
//  Created by Jonathan Wong  on 9/20/18.
//  Copyright © 2018 Jonathan Wong . All rights reserved.
//

import UIKit
import Foundation

struct Constants {
    
    struct Colors {
        static let mainBlue = UIColor(red: 100/255, green: 180/255, blue: 246/255, alpha: 1.0)
        static let darkBlue = UIColor(red: 20/255, green: 71/255, blue: 161/255, alpha: 1.0)
        static let otherBlue = UIColor(red: 34/255, green: 150/255, blue: 243/255, alpha: 1.0)
        static let darkGray = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        static let lightGray = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
    }
    struct Screen{
       static let widthFactor = UIScreen.main.bounds.size.width/375
       static let heightFactor = UIScreen.main.bounds.size.height/667
       static let width = UIScreen.main.bounds.size.width
       static let height = UIScreen.main.bounds.size.height
    }
}
