//
//  MainViewModel.swift
//  Haberle
//
//  Created by Cem Kazım on 31.03.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  KeyZim-MVVM
//

import Foundation

protocol MainViewModelDelegate: class {
    func setMainData(_ mainResultData: [MainModel])
}

class MainViewModel {
    
    // MARK: - Properties -
    
    var mainResultModel: MainResultModel?
    weak var delegate: MainViewModelDelegate?
    
    // MARK: - Initialize -
    
    init() {}
    
    // MARK: - Methods -
    
    func getData() {
        MainServiceLayer.shared.getMainData(pageNumber: 0, completionHandler: { [weak self] (data) in
            guard let self = self else { return }
            self.handleMainResponse(data)
            self.delegate?.setMainData(data)
        }, errorHandler: { (error) in
            print(error)
        })
    }
    
    func handleMainResponse(_ mainResponseData: [MainModel]) {
        for data in mainResponseData {
            if let response = data.response {
                handleMainResult(response)
            }
        }
    }
    
    func handleMainResult(_ mainResultData: MainResponseModel) {
        guard let results = mainResultData.results else { return }
        for data in results {
            // TO DO: Pass the data to view controller sayın cemocum...
        }
    }
}
