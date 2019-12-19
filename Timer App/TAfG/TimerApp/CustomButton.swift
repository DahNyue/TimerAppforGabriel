//
//  CustomButton.swift
//  TimerApp
//
//  Created by app.hanbat on 2017. 9. 12..
//  Copyright © 2017년 app.hanbat. All rights reserved.
//

import UIKit

class UIRoundPrimaryButton: UIButton{
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.layer.cornerRadius = 5.0;
        self.backgroundColor = UIColor(red: 255/255, green: 132/255, blue: 102/255, alpha: 1)
        self.tintColor = UIColor.white
    }
}
