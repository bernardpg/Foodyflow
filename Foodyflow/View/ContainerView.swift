//
//  ContainerView.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/17/22.
//

import UIKit

// MARK: - Protocol

@objc protocol SelectionViewDataSource: AnyObject {
        
    func totalButtomNumber(_ selectionView: ContainerView) -> Int
    
    func titleOfButton(_ selectionView: ContainerView, cellForEachSelect index: Int) -> String
    
    func underlineTextColor(_ selectionView: ContainerView) -> UIColor
    
    func selectTextColor(_ selectionView: ContainerView) -> UIColor
    
    func selectTextFont(_ selectionView: ContainerView) -> UIFont
 
    @objc optional func test() // optional 可做可不做
}

protocol SelectionViewDelegate: AnyObject {
    
    func didSelectedButton(_ selectionView: ContainerView, at index: Int)
    
    func shouldSelectedButton(_ selectionView: ContainerView, at index: Int) -> Bool
}

// MARK: - Protocol extension fundamental feature

extension SelectionViewDataSource {
    
    func numberOfButtons(_ selectionView: ContainerView) -> Int {
         2
    }
    
    func buttonFont(_ selectionView: ContainerView) -> UIFont {
         .systemFont(ofSize: 30)
    }
    
    func underlineTextColor(_ selectionView: ContainerView) -> UIColor {
         .blue
    }
    
    func selectTextColor(_ selectionView: ContainerView) -> UIColor {
        .white
    }
}

class ContainerView: UIView {
    
    // MARK: - Property
    
    weak var delegate: SelectionViewDelegate?
    
    weak var datasource: SelectionViewDataSource?{
        didSet {
            setUIProperty()
        }
    }
    
    var indicatorCenterXConstraint = NSLayoutConstraint()
    var myButtonColor = [UIColor.yellow, UIColor.blue]
    let buttonStack = UIStackView()
    var myButtonArray = [UIButton]()
    let anamationView = UIView()
    let changeView = UIView()
    
    // MARK: - SetUI()
    func setUIProperty() {
        let totalNumber = datasource?.totalButtomNumber(self)
        guard let totalNumber = totalNumber else { return }
        
        self.addSubview(buttonStack)
        for index in 0...totalNumber-1 {
            let eachButton: UIButton = {
                let button = UIButton()
                button.titleLabel?.font = datasource?.selectTextFont(self)
                button.setTitle(datasource?.titleOfButton(self, cellForEachSelect: index), for: .normal)
                button.setTitleColor(datasource?.selectTextColor(self), for: .normal)
                button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                button.backgroundColor = .black
                button.translatesAutoresizingMaskIntoConstraints = false
                button.contentVerticalAlignment = .center
                button.contentHorizontalAlignment = .center
                button.tag = index
                return button
            }()
            buttonStack.addArrangedSubview(eachButton)
            buttonStack.alignment = .fill
            buttonStack.distribution = .fillEqually
            buttonStack.spacing = 10
            buttonStack.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                buttonStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
                buttonStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
                buttonStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
                buttonStack.heightAnchor.constraint(equalToConstant: 20)
            ])
            
        }
        
        anamationView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(anamationView)
        NSLayoutConstraint.activate([
            anamationView.topAnchor.constraint(equalTo: buttonStack.arrangedSubviews[0].bottomAnchor, constant: 0),
            anamationView.widthAnchor.constraint(equalToConstant: 120),
            anamationView.heightAnchor.constraint(equalToConstant: 2)
        ])
        
        anamationView.backgroundColor = datasource?.underlineTextColor(self)
        
        changeView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(changeView)
        NSLayoutConstraint.activate([
            changeView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            changeView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            changeView.topAnchor.constraint(equalTo: self.anamationView.bottomAnchor, constant: 20),
            changeView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        changeView.backgroundColor = .red
    }
    
    // MARK: - button action
    @objc func buttonAction(sender: UIButton!) {
        if delegate?.shouldSelectedButton(self, at: sender.tag) ?? true {
            delegate?.didSelectedButton(self, at: sender.tag)
            let width = self.buttonStack.frame.width/CGFloat(datasource?.numberOfButtons(self) ?? 0)
            indicatorCenterXConstraint.constant = width * CGFloat(sender.tag)
            indicatorCenterXConstraint.isActive = false
            indicatorCenterXConstraint = anamationView.centerXAnchor.constraint(equalTo: sender.centerXAnchor)
            indicatorCenterXConstraint.isActive = true
            UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
                self.layoutIfNeeded()
            }.startAnimation()
        }
    }
}
