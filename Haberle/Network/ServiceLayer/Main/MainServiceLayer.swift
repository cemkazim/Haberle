//
//  MainServiceLayer.swift
//  Haberle
//
//  Created by Cem Kazım on 31.03.2021.
//

import Foundation
import RxSwift

class MainServiceLayer {
    
    static let shared = MainServiceLayer()
    private var disposeBag = DisposeBag()

    private init() {}
    
    func getMainData(pageNumber: Int, completionHandler: @escaping ([MainModel]) -> Void, errorHandler: @escaping (Error) -> Void) {
        BaseNetworkLayer
            .shared
            .request(requestUrl: setMainRequestURL(with: pageNumber),
                     requestMethod: .get)
            .subscribe(onNext: { (data) in
            completionHandler(data)
        }, onError: { (error: Error) in
            errorHandler(error)
        }).disposed(by: disposeBag)
    }
}

extension MainServiceLayer {
    
    func setMainRequestURL(with pageNumber: Int) -> String {
        return APIParameters.baseUrl.value + APIParameters.search.value + APIParameters.pageCount.value + String(pageNumber) + APIParameters.debate.value + APIParameters.api.value + APIParameters.apiKey.value
    }
}
