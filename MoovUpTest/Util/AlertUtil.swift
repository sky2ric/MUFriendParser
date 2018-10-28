//
//  AlertUtil.swift
//  MoovUpTest
//
//  Created by Sky Wong on 24/10/2018.
//  Copyright © 2018 Sky Wong. All rights reserved.
//

import UIKit

class AlertUtil: NSObject {
    
    static func showAlert(message: String){
        let alert = UIAlertController(title: "Error",
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            // click ok to ok
        }))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }

}
