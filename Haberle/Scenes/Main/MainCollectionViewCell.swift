//
//  MainCollectionViewCell.swift
//  Haberle
//
//  Created by Cem Kazım on 2.04.2021.
//

import UIKit
import WebKit

class MainCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties -
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.text = Constants.mainCollectionViewCellTitleText
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = .zero
        return label
    }()
    
    // MARK: - Initialize -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Methods -
    
    func setupView() {
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        setupConstraints()
        configureContainerView()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.widthAnchor.constraint(equalToConstant: 5 * frame.width / 6)
        ])
    }
    
    func configureContainerView() {
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 35
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = .zero
        layer.shadowRadius = 10
    }
}
