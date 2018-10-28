//
//  JsonReader.swift
//  MoovUpTest
//
//  Created by Sky Wong on 20/10/2018.
//  Copyright © 2018 Sky Wong. All rights reserved.
//

import UIKit

protocol JsonReaderDelegate {
    func didReceivedData(friends: [FriendObject])
    func didFailToReceiveData(error: NSError)
    func didFailToReceiveData()
}

class JsonReader: NSObject {

    var urlString: String
    var delegate: JsonReaderDelegate?
    
    init(urlString: String) {
        self.urlString = urlString
    }
    
    func GetDataFromURL() {
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.url = NSURL(string: urlString)! as URL
        request.httpMethod = "GET"
        
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue(), completionHandler:{ (response:URLResponse?, data: Data?, error: Error?) -> Void in
            //            var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
            if(data != nil){
                do{
                    //here dataResponse received from a network request
                    let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: [])
                    var friends: [FriendObject] = []
                    
                    // many jsons in one json response
                    if let array = jsonResponse as? [Any] {
                        // for each json in jsons
                        for object in array {
                            if let friend = self.parseDataFromJSON(json: object) {
                                friends.append(friend)
                            } else {
                                // nothing we can do here
                            }
                        }
                    }
                    
                    if(friends.count>0) {
                        self.delegate?.didReceivedData(friends: friends)
                    } else {
                        // no data
                        self.delegate?.didFailToReceiveData()
                    }
                    
                } catch let parsingError {
                    self.delegate?.didFailToReceiveData(error: parsingError as NSError)
                }
            } else {
                // no data
                self.delegate?.didFailToReceiveData()
            }
        })
    }
    
    private func parseDataFromJSON(json: Any) -> FriendObject?{
        
        if let dictionary = json as? [String: Any] {
            let friendobject = FriendObject.init(json: dictionary)
            return friendobject
        } else {
            return nil
        }
        
    }
    
    
}
