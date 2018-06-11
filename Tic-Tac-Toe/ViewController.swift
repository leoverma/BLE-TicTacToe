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
    
    var currentPlayer: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.mpcHandler.setupPeerWithDisplayName(displayName: UIDevice.current.name)
        appDelegate.mpcHandler.setupSession()
        appDelegate.mpcHandler.advertiseSelf(advertise: true)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(peerChangedStateWithNotification(notification:)),
                                               name: .MPC_DidChangeStateNotification ,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleReceiveDataWithNotification(notification:)),
                                               name: .MPC_DidReceiveDataNotification,
                                               object: nil)
        
        setupFields()
        self.currentPlayer = "x"
    }
    
    
    @IBAction func connectWithPlayer(_ sender: UIBarButtonItem) {
        
        if appDelegate.mpcHandler.session != nil {
            appDelegate.mpcHandler.setupBrowser()
            appDelegate.mpcHandler.browser.delegate = self as MCBrowserViewControllerDelegate
            self.present(appDelegate.mpcHandler.browser, animated: true, completion: nil)
        }
    }
    
    @IBAction func peerChangedStateWithNotification(notification: NSNotification){
        
        if let userInfo = notification.userInfo {
            let state = userInfo["state"] as! Int
            
            if state != MCSessionState.connecting.rawValue{
                self.navigationItem.title = "Connected"
            }
        }
        
    }
    
    
    @IBAction func handleReceiveDataWithNotification(notification: NSNotification){
        guard let userInfo = notification.userInfo else {
            return
        }
        print(userInfo)
        
        if let receivedData: Data = userInfo["data"] as? Data{
            let message = try! JSONSerialization.jsonObject(with: receivedData as Data, options: JSONSerialization.ReadingOptions.allowFragments)
            let senderPeerId: MCPeerID = userInfo["peerID"] as! MCPeerID
            let senderDisplayName = senderPeerId.displayName
            
//            print("\(message) - \(senderPeerId) - \(senderDisplayName)")
            
//            let field: Int? = (message as! [String: Any])["field"] as? Int
//            print("field == \(String(describing: field))")
            
            if let field = (message as! [String: Any])["field"] as? Int {
//              print("field == \(String(describing: field))")
                if let player = (message as! [String: Any])["player"] as? String {
//                    print("player == \(player)")
                    fields[field].player = player
                    fields[field].setPlayer(player)
                    
                    if player == "x" {
                        self.currentPlayer = "o"
                    }else{
                        self.currentPlayer = "x"
                    }
                    
                    // TODO: Check Result
                    checkResult()
                }
            }
            
        }
    }
    
    @IBAction func fieldTapped(recognizer: UITapGestureRecognizer){
        if let tappedField = recognizer.view as? TTTImageView{
            tappedField.setPlayer( self.currentPlayer)
            let messageDictionary = ["field": tappedField.tag, "player":self.currentPlayer] as [String : Any]
            
            let messageData = try! JSONSerialization.data(withJSONObject: messageDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            try? appDelegate.mpcHandler.session.send(messageData, toPeers: appDelegate.mpcHandler.session.connectedPeers, with: MCSessionSendDataMode.reliable)
            
            // TODO: CheckResult
            
            checkResult()
            
        }
        
        
        
    }
    
    
    func checkResult(){
        var winner = ""
        
        
        if fields[0].player == "x" && fields[1].player == "x" && fields[2].player == "x"{
            winner = "x"
        }else if fields[0].player == "o" && fields[1].player == "o" && fields[2].player == "o"{
            winner = "o"
        }
        if fields[0].player == "x" && fields[3].player == "x" && fields[6].player == "x"{
            winner = "x"
        }else if fields[0].player == "o" && fields[3].player == "o" && fields[6].player == "o"{
            winner = "o"
        }
        if fields[1].player == "x" && fields[4].player == "x" && fields[7].player == "x"{
            winner = "x"
        }else if fields[1].player == "o" && fields[4].player == "o" && fields[7].player == "o"{
            winner = "o"
        }
        if fields[2].player == "x" && fields[5].player == "x" && fields[8].player == "x"{
            winner = "x"
        }else if fields[2].player == "o" && fields[5].player == "o" && fields[8].player == "o"{
            winner = "o"
        }
        
        if fields[3].player == "x" && fields[4].player == "x" && fields[5].player == "x"{
            winner = "x"
        }else if fields[3].player == "o" && fields[4].player == "o" && fields[5].player == "o"{
            winner = "o"
        }
        
        if fields[6].player == "x" && fields[7].player == "x" && fields[8].player == "x"{
            winner = "x"
        }else if fields[6].player == "o" && fields[7].player == "o" && fields[8].player == "o"{
            winner = "o"
        }
        
        
        // Digonal
        if fields[0].player == "x" && fields[4].player == "x" && fields[8].player == "x"{
            winner = "x"
        }else if fields[0].player == "o" && fields[4].player == "o" && fields[8].player == "o"{
            winner = "o"
        }
        
        if fields[2].player == "x" && fields[4].player == "x" && fields[6].player == "x"{
            winner = "x"
        }else if fields[2].player == "o" && fields[4].player == "o" && fields[6].player == "o"{
            winner = "o"
        }
        print("Winner is \(winner)")
        
        if winner != "" {
        let alert = UIAlertController(title: "Winnner", message: "\(winner) is winner", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
        }
        
    }
    
    func setupFields(){
        for index in 0...fields.count - 1 {
            let gestureRecognizer = UITapGestureRecognizer(target: self,
                                                           action: #selector(fieldTapped(recognizer:)))
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

extension Notification.Name {
    static let MPC_DidChangeStateNotification = Notification.Name("MPC_DidChangeStateNotification")
    static let MPC_DidReceiveDataNotification = Notification.Name("MPC_DidReceiveDataNotification")
}
