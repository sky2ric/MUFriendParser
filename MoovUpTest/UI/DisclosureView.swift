//
//  DisclosureView.swift
//  MoovUpTest
//
//  Created by Sky Wong on 25/10/2018.
//  Copyright © 2018 Sky Wong. All rights reserved.
//

import UIKit
import MessageUI


class DisclosureView: UIViewController, MFMailComposeViewControllerDelegate {

    var friend: FriendObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func mainUIInit(){
        // hud init
        let hudWidth:CGFloat = view.frame.size.width - view.frame.size.width*0.1
        let hudHeight:CGFloat = view.frame.size.height/3
        let hudSize = CGSize(width: hudWidth, height: hudHeight);
        let hudView = UIView.init(frame: CGRect(origin: view.center, size: hudSize))
        hudView.center = self.view.center
        hudView.backgroundColor = UIColor.white
        
        // image init, just some random image taken from web
        let friendImage = UIImageView.init(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: hudView.frame.size.height/4, height: hudView.frame.size.height/4)))
        friendImage.center = CGPoint(x: hudView.frame.size.width/2, y: hudView.frame.size.height/4)
        friendImage.image = UIImage(named: "friend")
        hudView.addSubview(friendImage)
        
        // lets see what's left... ah the name
        let friendLabel = UILabel.init(frame: CGRect(x: 0, y: hudView.frame.size.height/2, width: hudView.frame.size.width, height: 20))
        friendLabel.text = friend?.name
        friendLabel.textAlignment = NSTextAlignment.center
        hudView.addSubview(friendLabel)
        
        let friendEmailLabel = UILabel.init(frame: CGRect(x: 0, y: hudView.frame.size.height/2 + 25, width: hudView.frame.size.width, height: 20))
        friendEmailLabel.text = friend?.email
        friendEmailLabel.textAlignment = NSTextAlignment.center
        hudView.addSubview(friendEmailLabel)
        // add a connector so the email can be composed instantly
        friendEmailLabel.isUserInteractionEnabled = true
        let sendEmailOnClick = UITapGestureRecognizer.init(target: self, action: #selector(DisclosureView.sendEmailAction))
        friendEmailLabel.addGestureRecognizer(sendEmailOnClick)
        
        // add a close button
        let closeButton = UIButton.init(frame: CGRect(x: 0, y: hudView.frame.size.height - 30, width: hudView.frame.size.width, height: 20))
        closeButton.setTitle("Close", for: UIControlState.normal)
        closeButton.setTitleColor(UIColor.gray, for: UIControlState.normal)
        closeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        closeButton.addTarget(self, action: #selector(DisclosureView.closeAction), for: UIControlEvents.touchUpInside)
        hudView.addSubview(closeButton)
        
        hudView.layer.cornerRadius = 10.0
        view.addSubview(hudView)
        
        // add the view to dismiss the backend
        let backgroundOnClick = UITapGestureRecognizer.init(target: self, action: #selector(DisclosureView.closeAction))
        self.view.addGestureRecognizer(backgroundOnClick)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mainUIInit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func closeAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func sendEmailAction(){
        if let email = friend?.email{
            if (MFMailComposeViewController.canSendMail())  {
                let emailTitle = "Hello!"
                let messageBody = "Sent from MoovUpTestApp"
                let toRecipents = [email]
                let mc:MFMailComposeViewController = MFMailComposeViewController()
                mc.mailComposeDelegate = self
                mc.setSubject(emailTitle)
                mc.setMessageBody(messageBody, isHTML: false)
                mc.setToRecipients(toRecipents)
                self.present(mc, animated: true, completion: nil)
            } else {
                    let alert = UIAlertController(title: "Cannot send email", message: "Set up your email account first.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)    
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
