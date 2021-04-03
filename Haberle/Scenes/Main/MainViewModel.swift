//
//  MainViewModel.swift
//  Haberle
//
//  Created by Cem Kazım on 31.03.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  KeyZim-MVVM
//

import UIKit

protocol MainViewModelDelegate: class {
    func setMainData(_ mainResult: [MainResultModel])
}

class MainViewModel {
    
    // MARK: - Properties -
    
    var mainResultList = [MainResultModel]()
    var backgroundColorList = [UIColor]()
    weak var delegate: MainViewModelDelegate?
    
    // MARK: - Initialize -
    
    init(delegate: MainViewModelDelegate) {
        self.delegate = delegate
        getMainData(currentPage: 1)
    }
    
    // MARK: - Methods -
    
    func getMainData(currentPage: Int) {
        MainServiceLayer.shared.getMainData(pageNumber: currentPage, completionHandler: { [weak self] (data) in
            guard let self = self else { return }
            self.getMainResponse(data)
        }, errorHandler: { (error) in
            print(error)
        })
    }
    
    func getMainResponse(_ responseData: [MainModel]) {
        for data in responseData {
            if let response = data.response {
                getMainResult(response)
            }
        }
        delegate?.setMainData(mainResultList)
    }
    
    func getMainResult(_ resultData: MainResponseModel) {
        guard let results = resultData.results else { return }
        for data in results {
            let model = MainResultModel(sectionName: data.sectionName, webTitle: data.webTitle, webUrl: data.webUrl)
            mainResultList.append(model)
        }
    }
}
