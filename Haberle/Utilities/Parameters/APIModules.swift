//
//  APIURL.swift
//  Haberle
//
//  Created by Cem Kazım on 31.03.2021.
//

import Foundation

enum APIParameters {
    
    typealias Value = String
    
    case baseUrl
    case search
    case pageCount
    case debate
    case api
    case apiKey
    
    var value: String {
        switch self {
        case .baseUrl:
            return "https://content.guardianapis.com"
        case .search:
            return "/search"
        case .pageCount:
            return "?page="
        case .debate:
            return "&q=debate"
        case .api:
            return "&api-key="
        case .apiKey:
            return "1238d9de-ea71-4f2a-9ca8-8002c1983d86"
        }
    }
}
