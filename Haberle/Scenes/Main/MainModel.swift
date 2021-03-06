//
//  MainModel.swift
//  Haberle
//
//  Created by Cem Kazım on 31.03.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  KeyZim-MVVM
//

import Foundation

struct MainModel: Decodable {
    
    let response: MainResponseModel?
    
    enum CodingKeys: String, CodingKey {
        case response
    }
}

struct MainResponseModel: Decodable {
    
    let results: [MainResultModel]?
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}

struct MainResultModel: Decodable {
    
    let sectionName: String?
    let webTitle: String?
    let webUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case sectionName
        case webTitle
        case webUrl
    }
}
