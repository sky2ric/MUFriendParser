//
//  FriendObject.swift
//  MoovUpTest
//
//  Created by Sky Wong on 20/10/2018.
//  Copyright © 2018 Sky Wong. All rights reserved.
//

import UIKit

//class FriendObject: NSObject {
//
//}

struct FriendObject {
    let name: String
    let picture: String
    let location: (latitude: Double, longitude: Double)
    let email: String
    let _id: String
}

extension FriendObject {
    init?(json: [String: Any]) {
        guard let name = json["name"] as? String,
            let coordinatesJSON = json["location"] as? [String: Double],
            let latitude = coordinatesJSON["latitude"],
            let longitude = coordinatesJSON["longitude"],
            let picture = json["picture"] as? String,
            let email = json["email"] as? String,
            let _id = json["_id"] as? String
            else {
                return nil
        }
        
        self.name = name
        self.location = (latitude, longitude)
        self.picture = picture
        self.email = email
        self._id = _id
    }
}
