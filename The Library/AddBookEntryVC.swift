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
    
    var book = Book(title: "Title", subtitle: nil, author: "Author", cover: nil, isbn: nil, location: Location())
    
    let loadingSpinner = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //setupSegmentedControl()
        entryModeSwitcher.addTarget(self, action: #selector(switcherWasTapped), for: .valueChanged)
        
        loadingSpinner.frame = CGRect(x: view.frame.width/2 - 25, y: view.frame.height/2 + 50, width: 50, height: 50)
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
        
        submitISBNButton.frame = CGRect(x: view.frame.width/2 - 150, y: view.safeAreaInsets.top+89+50, width: 300, height: 40)
        
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
        //show spinner
        view.addSubview(loadingSpinner)
        loadingSpinner.startAnimating()

        do{
            
            let sanitized = try sanitize(ISBNField.text ?? "")
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
                        self.book.ISBN = sanitized

                        if let oneLevelDeep = dictionary["ISBN:\(sanitized)"] as? [String: Any] {
                            // access nested dictionary values by key
                            print("One level deep decoded")
                            //Author
                            if let authorObject = oneLevelDeep["authors"] as? [ [String: Any] ] {
                                self.book.Author = authorObject[0]["name"] as! String
                            }
                            
                            //Title
                            if let title = oneLevelDeep["title"] as? String {
                                self.book.Title = title
                            }
                            
                            //Subtitle
                            if let subtitle = oneLevelDeep["subtitle"] as? String {
                                self.book.Subtitle = subtitle
                            }
                            //Cover
                            //Yikes this is gunna be tough
                            
                            //Publication year
                            if let publicationYear = oneLevelDeep["publish_date"] as? String {
                                self.book.PublicationYear = publicationYear
                            }
                        }
                    }
                }
                //Stop spinner
                DispatchQueue.main.async {
                    self.loadingSpinner.stopAnimating()
                }
                
                let confirmationAlert = UIAlertController(title: "This is what we found:", message: "\(self.book.Title) by \(self.book.Author). Does that look right?", preferredStyle: .alert)
                
                confirmationAlert.addAction(UIAlertAction(title: "Yup!", style: .default, handler: { (action) in
                    //TODO:- gotta actually put the book in the database here
                    print("Appending to database:")
                    Database.library.append(self.book)
                    print(self.book.Author)
                    print(self.book.Title)
                    print(self.book.Subtitle ?? "No subtitle")
                    print(self.book.PublicationYear ?? "No publication year")
                    print("Database:")
                    print(Database.library)
                    
                    let p = self.presentingViewController as! UINavigationController
                    let h = p.children[0] as! UITableViewController
                    h.tableView.reloadData()
                    
                    self.dismiss(animated: true, completion: nil)
                }))
                
                confirmationAlert.addAction(UIAlertAction(title: "Hm.. Let me try again", style: .destructive, handler: nil))
                
                DispatchQueue.main.async {
                    self.present(confirmationAlert, animated: true, completion: nil)
                }
                
                print(self.book.Author)
                print(self.book.Title)
                print(self.book.Subtitle ?? "No subtitle")
                print(self.book.PublicationYear ?? "No publication year")
                
            }
            task.resume()
            
        }catch ISBNError.InvalicCharactersInISBN{
            //Stop spinner
            DispatchQueue.main.async {
                self.loadingSpinner.stopAnimating()
            }
            
            let isbnAlert = UIAlertController(title: "Whoops", message: "ISBNs should only have digits and maybe dashes", preferredStyle: .alert)
            isbnAlert.addAction(UIAlertAction(title: "Got it", style: .default))
            
            self.present(isbnAlert, animated: true, completion: nil)
            
        }catch ISBNError.IncorrectISBNLength{
            //Stop spinner
            DispatchQueue.main.async {
                self.loadingSpinner.stopAnimating()
            }
            
            let isbnAlert = UIAlertController(title: "Whoops", message: "ISBNs are supposed to be either 10 or 13 digits long", preferredStyle: .alert)
            isbnAlert.addAction(UIAlertAction(title: "Got it", style: .default))
            
            self.present(isbnAlert, animated: true, completion: nil)
        }catch{
            //Stop spinner
            DispatchQueue.main.async {
                self.loadingSpinner.stopAnimating()
            }
            
            print(error)
        }
    }
    
    func sanitize(_ isbn: String) throws -> String {
        var ret = ""
        var flag = false
        isbn.forEach { (c) in
            if(c.isNumber || c.lowercased() == "x"){
                ret += "\(c)"
            }else if(!(c == "-")){
                flag = true
            }
        }
        if(flag){
            throw ISBNError.InvalicCharactersInISBN
        }
        if(!(ret.count == 10 || ret.count == 13)){
            throw ISBNError.IncorrectISBNLength
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
