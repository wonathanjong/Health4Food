//
//  Public_Functions.swift
//  SwipeMeIn
//
//  Created by Jonathan Wong  on 9/21/18.
//  Copyright © 2018 Jonathan Wong . All rights reserved.
//

import Foundation
import UIKit

public func RGB(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
}

public func RGB(x: CGFloat, a: CGFloat = 1.0) -> UIColor {
    return RGB(r: x, g: x, b: x, a: a)
}

//JSON Stringify function
func JSONStringify(value: [String:Any], prettyPrinted: Bool = false) -> String {
    let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : nil
    
    if JSONSerialization.isValidJSONObject(value) {
        if let data = try? JSONSerialization.data(withJSONObject: value, options: options!) {
            
            if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                return string as String
            }
        }
    }
    return ""
}


func dataToJSON(data: Data) -> [String:Any] {
    do {
        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
        //    let posts = json["posts"] as? [[String: Any]] ?? []
        //    print(posts)
        return json
    } catch let error as NSError {
        print(error)
        return [:]
    }
}

func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
    let attributedString = NSMutableAttributedString(string: string,
                                                     attributes: [NSAttributedString.Key.font: font])
    let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
    let range = (string as NSString).range(of: boldString)
    attributedString.addAttributes(boldFontAttribute, range: range)
    return attributedString
}
