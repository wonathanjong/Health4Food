//
//  Extensions.swift
//  Rematch
//
//  Created by Jonathan Wong  on 7/16/18.
//  Copyright © 2018 Jonathan Wong . All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    class func styledForLogin() -> UITextField {
        let textField = UITextField()
        textField.textColor = UIColor.black
        textField.layer.borderWidth = 1
        textField.layer.borderColor = RGB(x: 190).cgColor
        textField.backgroundColor = RGB(x: 230)
        textField.textAlignment = .center
        textField.spellCheckingType = .no
        textField.autocorrectionType = .no
        
        return textField
    }
}
class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0)
    let searchRect = CGRect(x: 0, y: 0, width: 30, height: 30)
    
//    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
//        return searchRect.inset(by: padding)
//    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
    
    func count(of needle: Character) -> Int {
        return reduce(0) {
            $1 == needle ? $0 + 1 : $0
        }
    }
}

extension UIImage {
    func imageLayerForShadow() -> UIImage {
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 0, y: 0, width: 1, height: 3)
        layer.colors = [UIColor(white: 0.0, alpha: 0.181).cgColor, UIColor(white: 1.0, alpha: 0.0).cgColor]
        
        UIGraphicsBeginImageContext(layer.frame.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension Date {
   
    static func getFormattedDate(string: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        
        let date: Date? = dateFormatterGet.date(from: "2018-02-01T19:10:04+00:00")
        print("Date", dateFormatterPrint.string(from: date!)) // Feb 01,2018
        return dateFormatterPrint.string(from: date!)
    }
    
    func asString(style: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: self)
    }
    
    static func isoToRegString(isoString: String) -> String {
        return (Date.dateFromISOString(string: isoString)?.asString(style: .medium))!
    }
    
    static func ISOStringFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        return dateFormatter.string(from: date).appending("Z")
    }
    
    static func dateFromISOString(string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        return dateFormatter.date(from: string)
    }
    
}
