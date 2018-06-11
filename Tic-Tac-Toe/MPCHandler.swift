//
//  MPCHandler.swift
//  Tic-Tac-Toe
//
//  Created by Manish Kumar on 6/8/18.
//  Copyright © 2018 v2solutions. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity

class MPCHandler: NSObject, MCSessionDelegate {
    
    var peerID:MCPeerID!
    var session:MCSession!
    
    var browser:MCBrowserViewController!
    var advertiser:MCAdvertiserAssistant?
    
    func setupPeerWithDisplayName(displayName:String){
        self.peerID = MCPeerID(displayName: displayName)
    }
    
    func setupSession(){
        self.session = MCSession(peer: self.peerID)
        session.delegate = self
    }
    
    func setupBrowser(){
        self.browser = MCBrowserViewController(serviceType: "my-Game", session: self.session)
    }
    
    func advertiseSelf(advertise: Bool){
        if (self.advertiser == nil){
            self.advertiser = MCAdvertiserAssistant(serviceType: "my-game", discoveryInfo: nil, session: self.session)
            advertiser?.start()
        }else{
            advertiser?.stop()
            self.advertiser=nil
        }
    }
    // MARK: MCSessionDelegate
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        let userInfo = ["peerID":peerID, "state":state.rawValue] as [String : Any]

        DispatchQueue.main.async {
//            print("Main thread")
            NotificationCenter.default.post(name: .MPC_DidChangeStateNotification, object: nil, userInfo: userInfo)
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let userInfo = ["data": data, "peerID":peerID] as [String: Any]
        DispatchQueue.main.async {
//            print("Main thread")
            NotificationCenter.default.post(name: .MPC_DidReceiveDataNotification, object: nil, userInfo: userInfo)
        }
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
}

