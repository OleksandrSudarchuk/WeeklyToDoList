//
//  PriorityColor.swift
//  WeeklyToDoList
//
//  Created by Oleksandr Sudarchuk on 13/01/2026.
//

import Foundation
import UIKit

enum PriorityColor: Int16 {
    case high = 0
    case medium = 1
    case low = 2
    
    var backgroundColor: UIColor {
        switch self {
        case .high: return UIColor.systemRed.withAlphaComponent(0.12)
        case .medium: return UIColor.systemYellow.withAlphaComponent(0.12)
        case .low: return UIColor.systemGreen.withAlphaComponent(0.12)
        }
    }
}

extension PriorityColor {
    static func from(_ raw: Int16?) -> PriorityColor? {
        guard let raw else {return nil}
        return PriorityColor(rawValue: raw)
    }
}
