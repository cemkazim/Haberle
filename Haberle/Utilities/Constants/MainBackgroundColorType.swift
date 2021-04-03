//
//  MainBackgroundColorType.swift
//  Haberle
//
//  Created by Cem Kazım on 3.04.2021.
//

import UIKit

enum MainBackgroundColorType: String {
    
    typealias Value = UIColor
    
    case sport = "Sport"
    case usNews = "US news"
    case environment = "Environment"
    case fashion = "Fashion"
    case politics = "Politics"
    case music = "Music"
    case ukNews = "UK news"
    case worldNews = "World news"
    case none
    
    var colorValue: UIColor {
        switch self {
        case .sport:
            return .green
        case .usNews:
            return .yellow
        case .environment:
            return .brown
        case .fashion:
            return .systemPink
        case .politics:
            return .lightGray
        case .music:
            return .blue
        case .ukNews:
            return .orange
        case .worldNews:
            return .purple
        default:
            return .white
        }
    }
}
