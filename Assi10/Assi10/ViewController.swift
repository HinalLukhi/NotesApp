//
//  ViewController.swift
//  Assi10
//
//  Created by DCS on 10/12/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let usernameLabel:UILabel={
        let label=UILabel()
        label.text = "ABC"
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize : 20)
        return label
        
    }()
    private let logoutButton:UIButton={
        let button=UIButton()
        button.setTitle("Logout", for: .normal)
        button.addTarget(self, action: #selector(LogoutTapped), for: .touchUpInside)
        button.backgroundColor = UIColor(red: 67/255, green: 117/255, blue: 191/255, alpha: 1.0)
        button.layer.cornerRadius = 6
        //button.setBackgroundImage(UIImage(named: "l2"), for: UIControl.State.normal)
        return button
    }()
    private var FileArray =  [String]()
    private let fileTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let add = UIBarButtonItem(barButtonSystemItem: .add,target: self, action: #selector(handleAdd))
        
        navigationItem.setRightBarButton(add, animated: true)
        navigationItem.title = "Notes"
        
        view.addSubview(usernameLabel)
        view.addSubview(logoutButton)
        view.addSubview(fileTableView)
        setupTableView()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkAuth()
        FileArray = []
        
        //FileArray = FMS.getFileList()
        for fname in FMS.getFileList()
        {
            let index = fname.firstIndex(of: ".")!
            if String(fname[index...]) == ".txt" {
               FileArray.append(String(fname[..<index]))
            }
        }
        fileTableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        usernameLabel.frame = CGRect(x: 20, y: 70, width: 200, height: 50)
        logoutButton.frame = CGRect(x: usernameLabel.right+70, y: 80, width: 80, height: 30)
        fileTableView.frame = CGRect(x: 0, y: usernameLabel.bottom+5, width:view.width, height: view.height - usernameLabel.height)
    }
    
    @objc func handleAdd()
    {
        let vc = NotesVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private func checkAuth()
    {
        if let uname = UserDefaults.standard.string(forKey: "username"){
            //print(uname)
            usernameLabel.text = "Welcome, \(uname)"
        }else{
            let vc = LogInVC()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            nav.setNavigationBarHidden(true, animated: false)
            present(nav,animated: true)
        }
    }
    
    @objc  func LogoutTapped(){
        UserDefaults.standard.setValue(nil, forKey: "username")
        checkAuth()
    }
}


extension ViewController: UITableViewDelegate,UITableViewDataSource {
    private func setupTableView()
    {
        fileTableView.dataSource = self
        fileTableView.delegate = self
        fileTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Filecell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FileArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Filecell", for: indexPath)
        cell.textLabel?.text = FileArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "All Notes"
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = NotesVC()
        vc.filename = FileArray[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let filepath = FMS.getDocDir().appendingPathComponent("\(FileArray[indexPath.row]).txt")
        
        do{
            try FileManager.default.removeItem(at: filepath)
            FileArray.remove(at: indexPath.row)
            fileTableView.deleteRows(at: [indexPath], with: .automatic)
        }catch {
            
            print(error)
        }
    }
}
