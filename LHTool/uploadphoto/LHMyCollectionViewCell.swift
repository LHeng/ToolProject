//
//  LHMyCollectionViewCell.swift
//  LHTool
//
//  Created by 刘恒 on 2018/7/19.
//  Copyright © 2018年 LH. All rights reserved.
//

import UIKit

class LHMyCollectionViewCell: UICollectionViewCell {
    typealias Block = (_ index : Int )->()

    @IBOutlet weak var myImageView: UIImageView!
    
    @IBOutlet weak var myButton: UIButton!
    
    var myblock : Block!
    
    var _myImage : UIImage = UIImage()
    var myImage :  UIImage {
        set {
            _myImage = newValue
            myImageView.image = newValue
        }
        get{
            return _myImage
        }
    }
    
    @IBAction func delPhoto(_ sender: UIButton) {
        if let _ = myblock {
            myblock(self.tag)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
