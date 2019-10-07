//
//  ViewController.swift
//  The Library
//
//  Created by Jacques Benzakein on 9/21/19.
//  Copyright © 2019 Q Technologies. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let library: [Book] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Try to reload data from firebase
        //if sucessful, overwrite file, change "last updated" time
        //if not, use data from stored json file
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Home"
        //setupAddButton()
    }

    func setupAddButton(){
        let addButton = UIButton()
        //TODO: Find a halfway decent place to put this button
        addButton.frame = CGRect(x: view.frame.width/2-50, y: view.frame.height/2-20, width: 100, height: 40)
        
        addButton.setTitle("Add", for: .normal)
        addButton.setTitleColor(.blue, for: .normal)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        view.addSubview(addButton)
        
    }
    @objc func addButtonTapped(){
        print("Plus!")
        let vcToPresent = AddBookEntryVC()
        present(vcToPresent, animated: true, completion: nil)
    }
}

