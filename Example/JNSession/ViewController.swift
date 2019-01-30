//
//  ViewController.swift
//  JNSession
//
//  Created by Jamal on 01/30/2019.
//  Copyright (c) 2019 Jamal. All rights reserved.
//

import UIKit
import JNSession

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        _ = JNSession.init(with: .init(baseLink: "http://jojo.io/"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}

