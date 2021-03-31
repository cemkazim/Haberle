//
//  MainViewController.swift
//  Haberle
//
//  Created by Cem Kazım on 31.03.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  KeyZim-MVVM
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Properties -
    
    lazy var viewModel: MainViewModel = {
        let viewModel = MainViewModel()
        viewModel.delegate = self
        return viewModel
    }()
    
    // MARK: - Lifecycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Methods -
}

extension MainViewController: MainViewModelDelegate {
    
    func setMainData(_ mainResultData: [MainModel]) {
        print(mainResultData)
    }
}
