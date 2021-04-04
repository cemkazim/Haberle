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
    lazy var mainPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    var isFiltered = false
    var mainTextField = UITextField()
    var mainViewModel: MainViewModel?
    
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
        setupConstraints()
        setupPickerView()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            mainCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupPickerView() {
        mainTextField.placeholder = Constants.chooseACategoryText
        mainTextField.textAlignment = .center
        view.addSubview(mainTextField)
        navigationItem.titleView = mainTextField
        mainTextField.inputView = mainPickerView
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.tintColor = .black
        toolbar.sizeToFit()
        let cancelButton = UIBarButtonItem(title: Constants.cancelButtonText, style: .done, target: self, action: #selector(cancelButtonTapped))
        let chooseButton = UIBarButtonItem(title: Constants.chooseButtonText, style: .done, target: self, action: #selector(chooseButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton, flexibleSpace, chooseButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        mainTextField.inputAccessoryView = toolbar
    }
    
    @objc func cancelButtonTapped() {
        isFiltered = false
        mainTextField.resignFirstResponder()
        mainTextField.text = ""
        mainCollectionView.reloadData()
    }
    
    @objc func chooseButtonTapped() {
        let selectedRowText = mainViewModel?.categoryList[mainPickerView.selectedRow(inComponent: 0)]
        mainTextField.text = selectedRowText
        filterMainResultList(selectedRowText)
        mainTextField.resignFirstResponder()
    }
    
    func filterMainResultList(_ selectedText: String?) {
        isFiltered = true
        mainViewModel?.filteredMainResultList = mainViewModel?.mainResultList.filter { $0.sectionName == selectedText } ?? []
        mainViewModel?.filteredBackgroundColorList = mainViewModel?.backgroundColorList.filter { $0.key == selectedText } ?? [:]
        mainCollectionView.reloadData()
    }
}

// MARK: - MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate -

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltered {
            return mainViewModel?.filteredMainResultList.count ?? 0
        } else {
            return mainViewModel?.mainResultList.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.mainCollectionViewCellId, for: indexPath) as? MainCollectionViewCell {
            if isFiltered {
                cell.titleLabel.text = mainViewModel?.filteredMainResultList[indexPath.row].webTitle
                cell.containerView.backgroundColor = mainViewModel?.filteredBackgroundColorList[mainViewModel?.filteredMainResultList[indexPath.row].sectionName ?? ""]
            } else {
                cell.titleLabel.text = mainViewModel?.mainResultList[indexPath.row].webTitle
                cell.containerView.backgroundColor = mainViewModel?.backgroundColorList[mainViewModel?.mainResultList[indexPath.row].sectionName ?? ""]
            }
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
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: getCollectionViewItemWidth(), height: getCollectionViewItemHeight())
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return getCollectionViewSpacing()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: getCollectionViewInset(), bottom: 0, right: getCollectionViewInset())
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageWidth: CGFloat = getCollectionViewItemWidth() + getCollectionViewSpacing()
        let currentPageOffset: CGFloat = scrollView.contentOffset.x
        let targetPageOffset: CGFloat = targetContentOffset.pointee.x
        var newPageOffset: CGFloat = 0
        if targetPageOffset > currentPageOffset {
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
    
    func getCollectionViewItemWidth() -> CGFloat {
        return 3 * view.frame.width / 4
    }
    
    func getCollectionViewItemHeight() -> CGFloat {
        return 2 * view.frame.height / 3
    }
    
    func getCollectionViewSpacing() -> CGFloat {
        return getCollectionViewItemWidth() / 10
    }
    
    func getCollectionViewInset() -> CGFloat {
        return 3 * view.frame.width / 25
    }
}

// MARK: - MainViewController: MainViewModelDelegate -

extension MainViewController: MainViewModelDelegate {
    
    func setMainData(_ mainResult: [MainResultModel]) {
        for result in mainResult {
            switch result.sectionName {
            case MainBackgroundColorType.sport.rawValue:
                mainViewModel?.backgroundColorList[MainBackgroundColorType.sport.rawValue] = MainBackgroundColorType.sport.colorValue
            case MainBackgroundColorType.usNews.rawValue:
                mainViewModel?.backgroundColorList[MainBackgroundColorType.usNews.rawValue] = MainBackgroundColorType.usNews.colorValue
            case MainBackgroundColorType.environment.rawValue:
                mainViewModel?.backgroundColorList[MainBackgroundColorType.environment.rawValue] = MainBackgroundColorType.environment.colorValue
            case MainBackgroundColorType.fashion.rawValue:
                mainViewModel?.backgroundColorList[MainBackgroundColorType.fashion.rawValue] = MainBackgroundColorType.fashion.colorValue
            case MainBackgroundColorType.politics.rawValue:
                mainViewModel?.backgroundColorList[MainBackgroundColorType.politics.rawValue] = MainBackgroundColorType.politics.colorValue
            case MainBackgroundColorType.music.rawValue:
                mainViewModel?.backgroundColorList[MainBackgroundColorType.music.rawValue] = MainBackgroundColorType.music.colorValue
            case MainBackgroundColorType.ukNews.rawValue:
                mainViewModel?.backgroundColorList[MainBackgroundColorType.ukNews.rawValue] = MainBackgroundColorType.ukNews.colorValue
            case MainBackgroundColorType.worldNews.rawValue:
                mainViewModel?.backgroundColorList[MainBackgroundColorType.worldNews.rawValue] = MainBackgroundColorType.worldNews.colorValue
            default:
                return
            }
        }
        mainCollectionView.reloadData()
    }
}

// MARK: - MainViewController: UIPickerViewDelegate, UIPickerViewDataSource -

extension MainViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mainViewModel?.categoryList.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return mainViewModel?.categoryList[row]
    }
}
