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
                //TODO:- First check all the fields and check if they're empty, and if they're not, throw an alert
                //Alert should have a "don't switch" and "switch anyway" button
                displayISBNView()
            }else{//... and now it's the Manual segment that's selected
                //TODO:- First check all the fields and check if they're empty, and if they're not, throw an alert
                //Alert should have a "don't switch" and "switch anyway" button
                displayManualView()
            }
            
        }//Otherwise no need ot update anything
    }
    
    //MARK:- ISBN 
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
    
    //MARK:- Manual View
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
        do{
            
            let sanitized = try sanitize(ISBNField.text ?? "")
            var book = Book(title: "Title", subtitle: nil, author: "Author", cover: nil, isbn: sanitized, location: Location())
            print("Fetching book data for ISBN \(sanitized)...")
            
            //If the ISBN was typed in corrently, let's fire off a request
            let session = URLSession.shared
            let url = URL(string: "https://openlibrary.org/api/books?bibkeys=ISBN:\(sanitized)&format=json&jscmd=data")!
            
            let task = session.dataTask(with: url) { (data, response, error) in
                //Check to make sure error!=nil
                //Check to make 'Status Code' in response is between 200 and 299
                
//                print("Data: \(String(describing: data))")
//                print("Response: \(String(describing: response))")
//                print("Error: \(String(describing: error))")
                
                
                guard let httpResponse = response as? HTTPURLResponse, let mime = httpResponse.mimeType, mime == "application/json" else {
                    print("Wrong MIME type!")
                    return
                }
                
                if let json = try? JSONSerialization.jsonObject(with: data!, options: []) {
//                    print(json)
                    if let dictionary = json as? [String: Any] {
                        
//                        for (key, value) in dictionary {
//                            // access all key / value pairs in dictionary
//                            print("Key: \(key)")
//                            print("Value: \(value)")
//                        }

                        if let oneLevelDeep = dictionary["ISBN:\(sanitized)"] as? [String: Any] {
                            // access nested dictionary values by key
                            print("One level deep decoded")
                            if let twoLevelsDeep = oneLevelDeep["authors"] as? [ [String: Any] ] {
                                print("Two levels deep decoded")
                                book.Author = twoLevelsDeep[0]["name"] as! String
                            }
                        }
                    }
                }
                
                print(book.Author)
                
            }
            task.resume()
            
        }catch JBError.InvalicCharactersInISBN{
            let isbnAlert = UIAlertController(title: "Whoops", message: "ISBNs should only have digits and maybe dashes", preferredStyle: .alert)
            isbnAlert.addAction(UIAlertAction(title: "Got it", style: .default))
            
            self.present(isbnAlert, animated: true, completion: nil)
            
        }catch JBError.IncorrectISBNLength{
            let isbnAlert = UIAlertController(title: "Whoops", message: "ISBNs are supposed to be either 10 or 13 digits long", preferredStyle: .alert)
            isbnAlert.addAction(UIAlertAction(title: "Got it", style: .default))
            
            self.present(isbnAlert, animated: true, completion: nil)
        }catch{
            print(error)
        }
    }
    
    func sanitize(_ isbn: String) throws -> String {
        var ret = ""
        var flag = false
        isbn.forEach { (c) in
            if(c.isNumber){
                ret += "\(c)"
            }else if(!(c == "-")){
                flag = true
            }
        }
        if(flag){
            throw JBError.InvalicCharactersInISBN
        }
        if(!(ret.count == 10 || ret.count == 13)){
            throw JBError.IncorrectISBNLength
        }
        return ret
    }
    
    func setupSegmentedControl(){
        let sc = UISegmentedControl()
        sc.insertSegment(withTitle: "ISBN", at: 0, animated: false)
        sc.insertSegment(withTitle: "Manual", at: 1, animated: false)
        
        sc.frame = CGRect(x: 0, y: 100, width: view.frame.width, height: 40)
        
        view.addSubview(sc)
    }
    
    
}
