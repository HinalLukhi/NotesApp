//
//  NotesVC.swift
//  Assi10
//
//  Created by DCS on 11/12/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import UIKit

class NotesVC: UIViewController {
    
    var filename: String?
    
    private let nameTextField:UITextField = {
        let textField = UITextField()
        textField.placeholder = ""
        textField.textAlignment = .left
        textField.backgroundColor = .white
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.cornerRadius = 6
        textField.autocorrectionType = .no
        return textField
    }()
    private let contenttextView:UITextView={
        let textview=UITextView()
        textview.text = ""
        textview.textAlignment = .left
        textview.backgroundColor = .white
        textview.layer.borderWidth = 1
        textview.layer.borderColor = UIColor.gray.cgColor
        textview.layer.cornerRadius = 6
        return textview
    }()
    private let saveButton:UIButton={
        let button=UIButton()
        button.setTitle("Save", for: .normal)
        button.addTarget(self, action: #selector(SaveNote), for: .touchUpInside)
        button.backgroundColor = .green
        button.layer.cornerRadius = 6
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(nameTextField)
        view.addSubview(contenttextView)
        view.addSubview(saveButton)
        
       
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let s1 = filename {
            nameTextField.text = s1
            nameTextField.isEnabled = false
            do{
                let filepath = FMS.getDocDir().appendingPathComponent("\(s1).txt")
                let fetchContent =  try String(contentsOf: filepath)
                contenttextView.text = fetchContent
                print(fetchContent)
            }catch{
                print(error)
            }
        }
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        nameTextField.frame = CGRect(x: 40, y: 100, width: view.width-80 , height: 40)
        contenttextView.frame = CGRect(x: 40, y: nameTextField.bottom+20, width: view.width-80, height: 300)
        saveButton.frame = CGRect(x: 40, y: contenttextView.bottom+20 , width: view.width-80, height: 40)
    }
    
    @objc private func SaveNote(){
        let name = nameTextField.text!
        let content = contenttextView.text!
        
        let filepath = FMS.getDocDir().appendingPathComponent("\(name).txt")
        
        do{
            try content.write(to: filepath, atomically: true, encoding: .utf8)
            resetField()
            navigationController?.popViewController(animated: true)
        }catch {
            print(error)
        }
    }
    
    func resetField()
    {
        nameTextField.text = ""
        contenttextView.text = ""
        filename = ""
        
    }

}
