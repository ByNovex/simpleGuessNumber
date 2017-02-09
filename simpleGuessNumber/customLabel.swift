//
//  customLabel.swift
//  simpleGuessNumber
//
//  Created by Byron Bacusoy Pinela on 7/2/17.
//  Copyright © 2017 Novex. All rights reserved.
//

import UIKit

class customLabel: UILabel {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        //self.layer.cornerRadius = 10.0;
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.5
        self.backgroundColor = UIColor.white
        self.textColor = UIColor.black
    }

}
