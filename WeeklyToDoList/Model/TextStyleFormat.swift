//
//  TextStyleFormat.swift
//  WeeklyToDoList
//
//  Created by Oleksandr Sudarchuk on 14/01/2026.
//

import Foundation
import UIKit

enum TextStyleFormat {
 
   static func attributedText(_ text: String, isDone: Bool) -> NSAttributedString {
        if isDone {
            return NSAttributedString(string: text, attributes: [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: UIColor.secondaryLabel
            ])
        } else {
            return NSAttributedString(string: text, attributes: [
                .strikethroughStyle: 0,
                .foregroundColor: UIColor.label])
        }
    
        }
    }
    

