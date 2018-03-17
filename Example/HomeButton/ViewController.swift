//
//  ViewController.swift
//  HomeButton
//
//  Created by nathangitter on 03/16/2018.
//  Copyright (c) 2018 nathangitter. All rights reserved.
//

import UIKit
import HomeButton

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HomeButton.style = .classic
        
    }

    override func prefersHomeIndicatorAutoHidden() -> Bool {
        return true
    }
}
