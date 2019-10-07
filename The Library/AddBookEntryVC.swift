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
    
    let ISBNField: UITextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //setupSegmentedControl()
        entryModeSwitcher.addTarget(self, action: #selector(switcherWasTapped), for: .valueChanged)
    }
    
    override func viewSafeAreaInsetsDidChange() {
        displayISBNView()
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
        
        ISBNField.textAlignment = .center
        ISBNField.placeholder = "10- or 13-digit ISBN"
        ISBNField.frame = CGRect(x: 20, y: view.safeAreaInsets.top+89, width: view.frame.width-40, height: 50)
        //ISBNField.topAnchor.constraint(equalTo: entryModeSwitcher.bottomAnchor).isActive = true
        view.addSubview(ISBNField)
        
        let submitISBNButton = UIButton()
        submitISBNButton.setTitle("Look up ISBN", for: .normal)
        submitISBNButton.setTitleColor(.blue, for: .normal)
        
        submitISBNButton.setTitle("Why you still holding the button?", for: .highlighted)
        submitISBNButton.setTitleColor(.blue, for: .highlighted)
        
        submitISBNButton.frame = CGRect(x: view.frame.width/2 - 75, y: view.safeAreaInsets.top+89+50, width: 150, height: 40)
        
        submitISBNButton.addTarget(self, action: #selector(submitISBN), for: .touchUpInside)
        view.addSubview(submitISBNButton)
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
    
    @objc func submitISBN(){
        let sanitized = sanitize(ISBNField.text ?? "")
        print("Fetching book data for ISBN \(sanitized)...")
    }
    
    func sanitize(_ isbn: String) -> String {
            return isbn
    }
    
    func setupSegmentedControl(){
        let sc = UISegmentedControl()
        sc.insertSegment(withTitle: "ISBN", at: 0, animated: false)
        sc.insertSegment(withTitle: "Manual", at: 1, animated: false)
        
        sc.frame = CGRect(x: 0, y: 100, width: view.frame.width, height: 40)
        
        view.addSubview(sc)
    }
    
    
}
