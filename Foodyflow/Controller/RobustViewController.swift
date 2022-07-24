//
//  RobustViewController.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 7/21/22.
//

import UIKit

class RobustViewController: UIViewController {

    var numberOfTimes = 0

    private var closure: (() -> Void) = { }

    init() {
        super.init(nibName: nil, bundle: nil)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        countIt()
    }

    func commonInit() {
        self.closure = {
            self.numberOfTimes += 1
            print(self.numberOfTimes)
        }
    }

    func countIt() {
        closure()
    }
}
