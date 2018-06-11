//
//  ViewController.swift
//  Tic-Tac-Toe
//
//  Created by Manish Kumar on 6/8/18.
//  Copyright © 2018 v2solutions. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, MCBrowserViewControllerDelegate {

    

    @IBOutlet var fields: [TTTImageView]!
    var appDelegate:AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.mpcHandler.setupPeerWithDisplayName(displayName: UIDevice.current.name)
        appDelegate.mpcHandler.setupSession()
        appDelegate.mpcHandler.advertiseSelf(advertise: true)
        
//        NotificationCenter.default.addObserver(self,
//                                               selector: Selector(("peerChangedStateWithNotification")),
//                                               name: NSNotification.Name(rawValue: "MPC_DidChangeStateNotification"),
//                                               object: nil)
        
    }
    
    
    @IBAction func connectWithPlayer(_ sender: UIBarButtonItem) {
        
        if appDelegate.mpcHandler.session != nil {
            appDelegate.mpcHandler.setupBrowser()
            appDelegate.mpcHandler.browser.delegate = self as MCBrowserViewControllerDelegate
            self.present(appDelegate.mpcHandler.browser, animated: true, completion: nil)
        }
    }
    
    func setupGameLogic(){
        for index in 0...fields.count - 1 {
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: Selector(("fieldTapped:")))
            gestureRecognizer.numberOfTapsRequired = 1
            
            fields[index].addGestureRecognizer(gestureRecognizer)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: MCBrowserViewControllerDelegate
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        appDelegate.mpcHandler.browser.dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        appDelegate.mpcHandler.browser.dismiss(animated: true, completion: nil)
    }
}

