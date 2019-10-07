//
//  AddBookEntryVC.swift
//  The Library
//
//  Created by Jacques Benzakein on 9/22/19.
//  Copyright © 2019 Q Technologies. All rights reserved.
//

import UIKit

class AddBookEntryVC: UIViewController {

    @IBOutlet weak var entryModeSwitcher: UISegmentedControl!
    
    var lastSelected: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //setupSegmentedControl()
        displayISBNView()
        entryModeSwitcher.addTarget(self, action: #selector(switcherWasTapped), for: .valueChanged)
    }
    
    
    @objc func switcherWasTapped(){
        let currentlySelected: Int = entryModeSwitcher.selectedSegmentIndex
        if(currentlySelected != lastSelected){//As in, if something changed...
            lastSelected = currentlySelected
            
            if(currentlySelected == 0){//... and now it's the ISBN segment that was selected
                displayISBNView()
            }else{//... and now it's the Manual segment that's selected
                displayManualView()
            }
            
        }//Otherwise no need ot update anything
    }
    
    func displayISBNView(){
        view.subviews.forEach { (awaitingFate) in
            if(!(awaitingFate is UISegmentedControl)){
                awaitingFate.removeFromSuperview()
            }
        }
        
        let testLabel = UILabel()
        testLabel.text = "ISBN test"
        testLabel.frame = CGRect(x: 0, y: view.frame.height/2, width: view.frame.width, height: 70)
        view.addSubview(testLabel)
    }
    
    func displayManualView(){
        view.subviews.forEach { (awaitingFate) in
            if(!(awaitingFate is UISegmentedControl)){
                awaitingFate.removeFromSuperview()
            }
        }
        
        let testLabel = UILabel()
        testLabel.text = "Manual test"
        testLabel.frame = CGRect(x: 0, y: view.frame.height/2, width: view.frame.width, height: 70)
        view.addSubview(testLabel)
    }
    
    func setupSegmentedControl(){
        let sc = UISegmentedControl()
        sc.insertSegment(withTitle: "ISBN", at: 0, animated: false)
        sc.insertSegment(withTitle: "Manual", at: 1, animated: false)
        
        sc.frame = CGRect(x: 0, y: 20, width: view.frame.width, height: 40)
        
        view.addSubview(sc)
    }
    
    
}
