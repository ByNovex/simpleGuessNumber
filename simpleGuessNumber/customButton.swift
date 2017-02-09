//
//  customButton.swift
//  simpleGuessNumber
//
//  Created by Byron Bacusoy Pinela on 7/2/17.
//  Copyright © 2017 Novex. All rights reserved.
//

import UIKit

class customButton: UIButton {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.layer.cornerRadius = 10.0;
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.5
        self.backgroundColor = UIColor.white
        //self.tintColor = UIColor(red: 204.0, green: 204.0, blue: 204.0, alpha: 1.0)//silverColor.
        self.tintColor = UIColor.red
    }
}
