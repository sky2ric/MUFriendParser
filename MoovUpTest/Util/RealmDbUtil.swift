//
//  RealmDbUtil.swift
//  MoovUpTest
//
//  Created by Sky Wong on 24/10/2018.
//  Copyright © 2018 Sky Wong. All rights reserved.
//

import UIKit
import RealmSwift

class RealmDbUtil: NSObject {

    var friends: [FriendObject]
    
    init(friends: [FriendObject]) {
        self.friends = friends
    }
    
    func writeDatabase(){
        let realm = try! Realm()
        let result = realm.objects(FriendDB.self)
        try! realm.write {
            realm.delete(result)
        }
        
        // put friends into friend structure
        for friend in friends{
            let frienddb = FriendDB()
            frienddb.name = friend.name
            frienddb.email = friend.email
            frienddb._id = friend._id
            frienddb.picture = friend.picture
            frienddb.location_lat = friend.location.latitude
            frienddb.location_long = friend.location.longitude
            
            try! realm.write {
                realm.add(frienddb)
            }
        }
    }
    
    // no id = "" query is needed, static function implemented
    static func readDatabase()->[FriendObject]{
        let realm = try! Realm()
        let friendsDb = realm.objects(FriendDB.self)
        var friends: [FriendObject] = []
        for friend in friendsDb{
            let friend = FriendObject(name: friend.name,
                                      picture: friend.picture,
                                      location: (friend.location_lat, friend.location_long),
                                      email: friend.email,
                                      _id: friend._id)
            friends.append(friend)
        }

        return friends
    }
    
}

class FriendDB: Object{
    @objc dynamic var name = ""
    @objc dynamic var picture = ""
    @objc dynamic var location_lat = 0.0
    @objc dynamic var location_long = 0.0
    @objc dynamic var email = ""
    @objc dynamic var _id = ""
}
