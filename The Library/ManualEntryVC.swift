//
//  ManualEntryVC.swift
//  The Library
//
//  Created by Jacques Benzakein on 10/6/19.
//  Copyright © 2019 Q Technologies. All rights reserved.
//

import UIKit

class ManualEntryVC: UIViewController {
    
    let titleTextField = UITextField()
    let subtitleTextField = UITextField()
    let authorTextField = UITextField()
    
    let xPadding:CGFloat = 20
    let yPadding:CGFloat = 20
    let h:CGFloat = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        // Do any additional setup after loading the view.
//        view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
//        setupEntryForm()
//        setupDoneButton()
//        setupCancelButton()
    }
    
    func setupEntryForm(){
        
        setupTitleFields()
        
        setupSubitleFields()
        
        setupAuthorFields()
        
        //Cover
        //Label
        let coverLabel = UILabel()
        coverLabel.text = "Cover"
        coverLabel.frame = CGRect(x: xPadding, y: 4*yPadding+6*h, width: (view.frame.width - (xPadding*2)), height: h)
        view.addSubview(coverLabel)
        //Field
        
        //ISBN
        //Label
        //Field
        
        //Location
        //Label
        //Field
    }
    
    func setupDoneButton(){
        let doneButton = UIButton()
        //TODO: Find a halfway decent place to put this button
        doneButton.frame = CGRect(x: view.frame.width/2-50, y: view.frame.height/2, width: 100, height: 40)
        
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(.blue, for: .normal)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        view.addSubview(doneButton)
    }
    
    func setupCancelButton(){
        let cancelButton = UIButton()
        //TODO: Find a halfway decent place to put this button
        cancelButton.frame = CGRect(x: view.frame.width/2-50, y: view.frame.height/2+20, width: 100, height: 40)
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.red, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        view.addSubview(cancelButton)
    }
    
    @objc func doneButtonTapped(){
        print("Book was added!")
        if(!titleTextField.hasText && !authorTextField.hasText){
            //Error saying they're required
            let alert = UIAlertController(title: "Title and author are required", message: "Looks like the title and author fields might be empty, please fill them in if they are", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Got it", style: .default, handler: nil))
            self.present(alert, animated: true)
        }else if(!titleTextField.hasText){
            let alert = UIAlertController(title: "Title is required", message: "Looks like the title field might be empty, please fill it in if it is", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Got it", style: .default, handler: nil))
            self.present(alert, animated: true)
        }else if(!authorTextField.hasText){
            let alert = UIAlertController(title: "Author is required", message: "Looks like the author field might be empty, please fill it in if it is", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Got it", style: .default, handler: nil))
            self.present(alert, animated: true)
        }else{
            let location = Location()
            let book = Book(title: titleTextField.text!, subtitle: subtitleTextField.text, author: authorTextField.text!, cover: nil, isbn: nil, location: location)
            //Add book to userdefaults array
            print("Added \(book.Title) by \(book.Author)")
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func cancelButtonTapped(){
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func setupTitleFields() {
        //Title
        //Label
        let titleLabel = UILabel()
        titleLabel.text = "Title*"
        titleLabel.frame = CGRect(x: xPadding, y: yPadding, width: (view.frame.width - (xPadding*2)), height: h)
        view.addSubview(titleLabel)
        
        //Field
        titleTextField.frame = CGRect(x: 0, y: yPadding+h, width: view.frame.width, height: h)
        titleTextField.backgroundColor = .white
        titleTextField.clearButtonMode = .whileEditing
        titleTextField.returnKeyType = .done
        view.addSubview(titleTextField)
    }
    
    fileprivate func setupSubitleFields() {
        //Subtitle
        //Label
        let subtitleLabel = UILabel()
        subtitleLabel.text = "Subtitle"
        subtitleLabel.frame = CGRect(x: xPadding, y: 2*yPadding+2*h, width: (view.frame.width - (xPadding*2)), height: h)
        view.addSubview(subtitleLabel)
        
        //Field
        subtitleTextField.frame = CGRect(x: 0, y: 2*yPadding+3*h, width: view.frame.width, height: h)
        subtitleTextField.backgroundColor = .white
        subtitleTextField.clearButtonMode = .whileEditing
        subtitleTextField.returnKeyType = .done
        view.addSubview(subtitleTextField)
    }
    
    fileprivate func setupAuthorFields() {
        //Author
        //Label
        let authorLabel = UILabel()
        authorLabel.text = "Author*"
        authorLabel.frame = CGRect(x: xPadding, y: 3*yPadding+4*h, width: (view.frame.width - (xPadding*2)), height: h)
        view.addSubview(authorLabel)
        //Field
        authorTextField.frame = CGRect(x: 0, y: 3*yPadding+5*h, width: view.frame.width, height: h)
        authorTextField.backgroundColor = .white
        authorTextField.autocapitalizationType = .words
        authorTextField.clearButtonMode = .whileEditing
        authorTextField.returnKeyType = .done
        //        authorTextField.borderStyle = .roundedRect
        view.addSubview(authorTextField)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
