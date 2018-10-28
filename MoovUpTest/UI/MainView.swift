//
//  MainView.swift
//  MoovUpTest
//
//  Created by Sky Wong on 20/10/2018.
//  Copyright © 2018 Sky Wong. All rights reserved.
//

import UIKit


class MainView: UIViewController, MainControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    

    // a spinning thing to indicate something is going on.
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    // table view and refresh controller to let user see results and refresh
    private var friendsTableView: UITableView!
    private var refreshControl: UIRefreshControl!
    private var manualRefreshButton: UIButton?
    
    // controller for this view, a demonstration of showing i'm trying to do MVC here
    let mainController = MainController()
    
    // data(friends) container
    private var friends: [FriendObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mainUIInit()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // hand over control to MainController
        mainController.mainViewDelegate = self
        mainController.getAvailableData()
    }

    // MARK: UI
    func mainUIInit(){
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "All Friends"
        
        activityView.center = self.view.center
        self.view.addSubview(activityView)
        activityView.isHidden = true
        
        spinnerStart()
    }
    
    func mainTableInit(){
        // UITableView
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        friendsTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        friendsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "FriendCell")
        friendsTableView.dataSource = self
        friendsTableView.delegate = self
        
        // UIRefreshView
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshTableData), for: .valueChanged)
        friendsTableView.addSubview(refreshControl)
        
        self.view.addSubview(friendsTableView)
    }
    
    @objc func refreshTableData(refreshControl: UIRefreshControl) {
        mainController.getAvailableData()
    }
    
    func spinnerStop(){
        activityView.stopAnimating()
        activityView.isHidden = true
    }
    
    func spinnerStart(){
        activityView.startAnimating()
        activityView.isHidden = false
    }
    
    func refreshViewStop(){
        if(refreshControl != nil && refreshControl.isRefreshing){
            refreshControl.endRefreshing()
        }
    }
    
    // MARK: Call Backs from Controller
    func dataIsReady(friends: [FriendObject]) {
        DispatchQueue.main.async{
            self.friends = friends
            self.spinnerStop()
            self.refreshViewStop()
            self.mainTableInit()
        }
    }
    
    func dataNotReady(error: NSError) {
        // stop spinning
        DispatchQueue.main.async{
            self.spinnerStop()
            self.refreshViewStop()
            AlertUtil.showAlert(message: "Data incorrect")
        }
    }
    
    func dataEmpty() {
        // stop spinning
        DispatchQueue.main.async{
            self.spinnerStop()
            self.refreshViewStop()
            AlertUtil.showAlert(message: "No data available")
        }
    }
    
    // MARK: UITableView UI
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = MapView()
        detailVC.friend = friends[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath as IndexPath)
        cell.textLabel!.text = "\(friends[indexPath.row].name)"
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

