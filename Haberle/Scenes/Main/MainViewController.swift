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
    
    lazy var mainCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.setCollectionViewLayout(flowLayout, animated: true)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: CellIdentifiers.mainCollectionViewCellId)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.backgroundView = UIView.init(frame: .zero)
        collectionView.decelerationRate = .fast
        return collectionView
    }()
    var mainViewModel: MainViewModel?
    var minimumLineSpacing: CGFloat = 30
    
    // MARK: - Lifecycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Methods -
    
    func setupView() {
        view.addSubview(mainCollectionView)
        mainViewModel = MainViewModel(delegate: self)
        view.backgroundColor = .white
        navigationItem.title = Constants.mainNavigationItemTitle
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            mainCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate -

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainViewModel?.backgroundColorList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.mainCollectionViewCellId, for: indexPath) as? MainCollectionViewCell {
            cell.containerView.backgroundColor = mainViewModel?.backgroundColorList[indexPath.row]
            cell.titleLabel.text = mainViewModel?.mainResultList[indexPath.row].webTitle
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let webViewURL = mainViewModel?.mainResultList[indexPath.row].webUrl, let formattedURL = URL(string: webViewURL) {
            let newsWebView = NewsWebViewController()
            let loadedURL = URLRequest(url: formattedURL)
            newsWebView.webView.load(loadedURL)
            let rootViewController = UINavigationController(rootViewController: newsWebView)
            present(rootViewController, animated: true, completion: nil)
        } else {
            print("error")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 325, height: 550)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 45, bottom: 0, right: 45)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageWidth: CGFloat = 325 + minimumLineSpacing
        let currentPageOffset: CGFloat = scrollView.contentOffset.x
        let targetOffset: CGFloat = targetContentOffset.pointee.x
        var newPageOffset: CGFloat = 0
        if targetOffset > currentPageOffset {
            newPageOffset = ceil(currentPageOffset / pageWidth) * pageWidth
        } else {
            newPageOffset = floor(currentPageOffset / pageWidth) * pageWidth
        }
        if newPageOffset < 0 {
            newPageOffset = 0
        } else if newPageOffset > scrollView.contentSize.width {
            newPageOffset = scrollView.contentSize.width
        }
        targetContentOffset.pointee.x = currentPageOffset
        scrollView.setContentOffset(CGPoint(x: newPageOffset, y: 0), animated: true)
    }
}

// MARK: - MainViewController: MainViewModelDelegate -

extension MainViewController: MainViewModelDelegate {
    
    func setMainData(_ mainResult: [MainResultModel]) {
        for result in mainResult {
            switch result.sectionName {
            case MainBackgroundColorType.sport.rawValue:
                mainViewModel?.backgroundColorList.append(MainBackgroundColorType.sport.colorValue)
            case MainBackgroundColorType.usNews.rawValue:
                mainViewModel?.backgroundColorList.append(MainBackgroundColorType.usNews.colorValue)
            case MainBackgroundColorType.environment.rawValue:
                mainViewModel?.backgroundColorList.append(MainBackgroundColorType.environment.colorValue)
            case MainBackgroundColorType.fashion.rawValue:
                mainViewModel?.backgroundColorList.append(MainBackgroundColorType.fashion.colorValue)
            case MainBackgroundColorType.politics.rawValue:
                mainViewModel?.backgroundColorList.append(MainBackgroundColorType.politics.colorValue)
            case MainBackgroundColorType.music.rawValue:
                mainViewModel?.backgroundColorList.append(MainBackgroundColorType.music.colorValue)
            case MainBackgroundColorType.ukNews.rawValue:
                mainViewModel?.backgroundColorList.append(MainBackgroundColorType.ukNews.colorValue)
            case MainBackgroundColorType.worldNews.rawValue:
                mainViewModel?.backgroundColorList.append(MainBackgroundColorType.worldNews.colorValue)
            default:
                return
            }
        }
        mainCollectionView.reloadData()
    }
}
