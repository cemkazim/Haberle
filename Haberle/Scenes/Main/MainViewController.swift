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
    
    lazy var cardViewComponent: MainCardViewComponent = {
        let component = MainCardViewComponent()
        component.translatesAutoresizingMaskIntoConstraints = false
        return component
    }()
    lazy var viewModel: MainViewModel = {
        let viewModel = MainViewModel()
        viewModel.delegate = self
        return viewModel
    }()
    
    // MARK: - Lifecycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Methods -
    
    func setupView() {
        view.addSubview(cardViewComponent)
        view.backgroundColor = .white
        navigationItem.title = Constants.mainNavigationItemTitle
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            cardViewComponent.topAnchor.constraint(equalTo: view.topAnchor),
            cardViewComponent.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cardViewComponent.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cardViewComponent.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - MainViewController: MainViewModelDelegate -

extension MainViewController: MainViewModelDelegate {
    
    func setMainData(_ mainResult: [MainResultModel]) {
        print(mainResult)
    }
}
