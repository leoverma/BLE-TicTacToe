//
//  TTTImageView.swift
//  Tic-Tac-Toe
//
//  Created by Manish Kumar on 6/8/18.
//  Copyright © 2018 v2solutions. All rights reserved.
//

import Foundation
import UIKit
class TTTImageView: UIImageView{
    var player:String?
    var activated:Bool = false
    
    
    func setPlayer(_ player:String){
        self.player = player
        if activated == false {
            if self.player == "x" {
                self.image = UIImage(named: "cross")
            }else {
                self.image = UIImage(named: "zero")
            }
            activated = true
        }
    }
    
    
}
