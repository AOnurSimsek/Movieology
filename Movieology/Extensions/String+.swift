//
//  String+.swift
//  Movieology
//
//  Created by Abdullah onur Şimşek on 14.08.2022.
//

import UIKit

extension String {
    func getTitleAttributedString(text: String, hightlightedText:String) -> NSMutableAttributedString {
        let wholeString: String = hightlightedText + text
        let range = ((wholeString) as NSString).range(of: hightlightedText)
        
        let attributeString = NSMutableAttributedString(string: wholeString,
                                                        attributes: [.font: UIFont(name: "Roboto-Regular", size: 16) as Any,
                                                                     .foregroundColor: UIColor.white])
        let secondAttribute = [.font: UIFont(name: "Roboto-Bold", size: 20) as Any ] as [NSAttributedString.Key : Any]
        attributeString.addAttributes(secondAttribute, range: range)
        return attributeString
    }
    
    func getDate() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        if let date = formatter.date(from: self) {
            formatter.dateFormat = "dd MMM yyyy"
            return formatter.string(from: date)
        } else {
            return ""
        }
    }
}
