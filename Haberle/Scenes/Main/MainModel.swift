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
}

struct MainResponseModel: Decodable {
    let results: [MainResultModel]?
}

struct MainResultModel: Decodable {
    let sectionName: String?
    let webTitle: String?
    let webUrl: String?
}
