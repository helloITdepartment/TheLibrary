//
//  ViewController.swift
//  The Library
//
//  Created by Jacques Benzakein on 9/21/19.
//  Copyright © 2019 Q Technologies. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Try to reload data from firebase
        //if sucessful, overwrite file, change "last updated" time
        //if not, use data from stored json file
        print("will appear")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Home"
        print("View did load")
        print("Library: \(Database.library)")
    }

}

