//
//  WithinThreeDaysView.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 7/15/22.
//

import Foundation
import UIKit

class WithinThreeDaysView: UIView {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "withinthreesFrame")
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "你的冰箱目前沒有三日內食物 "
        label.font = UIFont(name: "AvenirNext-Medium", size: 16)!
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    // not call static view till it's been caught
    // access all  property within the class
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ imageView, titleLabel ])
        stackView.axis = .vertical
        stackView.spacing = 60
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8), // with contentview
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 100),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
}
