//
//  ViewController.swift
//  SearchBar
//
//  Created by Ben Meline on 11/16/15.
//  Copyright © 2015 Ben Meline. All rights reserved.
//

import UIKit
import PureLayout

class ViewController: UIViewController {

    private var mainView: MainView!
    private var didSetupConstraints = false
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView = MainView.newAutoLayoutView()
        view.addSubview(mainView)
    }
    
    // MARK: - Layout
    
    override func updateViewConstraints() {
        if !didSetupConstraints {
            mainView.autoPinToTopLayoutGuideOfViewController(self, withInset: 0)
            mainView.autoPinToBottomLayoutGuideOfViewController(self, withInset: 0)
            mainView.autoPinEdgeToSuperviewEdge(.Leading)
            mainView.autoPinEdgeToSuperviewEdge(.Trailing)
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
}

