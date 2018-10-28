//
//  MainController.swift
//  MoovUpTest
//
//  Created by Sky Wong on 22/10/2018.
//  Copyright © 2018 Sky Wong. All rights reserved.
//

import UIKit

protocol MainControllerDelegate {
    func dataIsReady(friends: [FriendObject])
    func dataNotReady(error: NSError)
    func dataEmpty()
}

class MainController: NSObject, JsonReaderDelegate {

    // Change this if you want to get json from somewhere else
    static let URLFORFRIENDSDATA: String = "http://www.json-generator.com/api/json/get/cfdlYqzrfS"
    var jsonReader = JsonReader(urlString: URLFORFRIENDSDATA)
    
    // delegate for main view
    var mainViewDelegate: MainControllerDelegate?
    
    func getAvailableData(){
        // load information from JSON
        jsonReader.GetDataFromURL()
        jsonReader.delegate = self
    }
    
    // MARK: Json Reader and Parser
    func didReceivedData(friends: [FriendObject]){
        // we have got friends in here -> write into local database async
        writeLocalDatabase(friends: friends)

        // tell the main view data is ready
        mainViewDelegate?.dataIsReady(friends: friends)
    }
    
    func didFailToReceiveData(error: NSError) {
        // received error -> show error
        if let friends = getLocalDatabase(){
            mainViewDelegate?.dataIsReady(friends: friends)
        } else {
            mainViewDelegate?.dataNotReady(error: error)
        }
    }
    
    func didFailToReceiveData(){
        if let friends = getLocalDatabase(){
            mainViewDelegate?.dataIsReady(friends: friends)
        } else {
            mainViewDelegate?.dataEmpty()
        }
    }
    
    // MARK: Local Database Reader and Writer
    func writeLocalDatabase(friends: [FriendObject]){
        let writeDb = RealmDbUtil(friends: friends)
        writeDb.writeDatabase()
    }
    
    func getLocalDatabase()->[FriendObject]?{
        let friends: [FriendObject] = RealmDbUtil.readDatabase()
        return friends
    }

    
}
