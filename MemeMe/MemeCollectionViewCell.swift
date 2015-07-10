//
//  MemeCollectionViewCell.swift
//  MemeMe
//
//  Created by Jing on 2015-07-09.
//  Copyright (c) 2015 Jing. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var topText: UILabel!
    @IBOutlet weak var bottomText: UILabel!
    @IBOutlet weak var imageView: UIImageView!
   
    let TextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 20)!,
        NSStrokeWidthAttributeName : -4.0
    ]
    
    // set the top and bottom labels as well as the text attributes
    func setText (topText: String, bottomText: String) {
       
        self.topText.attributedText = NSMutableAttributedString(string: topText, attributes: TextAttributes)
        self.bottomText.attributedText = NSMutableAttributedString(string: bottomText, attributes: TextAttributes)

    }
}
