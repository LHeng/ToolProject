//
//  LHMyTableViewCell.swift
//  LHTool
//
//  Created by 刘恒 on 2018/7/18.
//  Copyright © 2018年 LH. All rights reserved.
//

import UIKit

class LHMyTableViewCell: UITableViewCell {

    typealias Block = (_ choose : Bool, _ index : Int) ->()

    @IBOutlet weak var myButton: UIButton!
    @IBOutlet weak var myLabel: UILabel!
    var myBlock : Block!
    
    var _isChoose : Bool = false
    
    var isChoose : Bool {
        set {
            _isChoose = newValue
            myButton.isSelected = _isChoose
        }
        get {
            return _isChoose
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func ButtonEvent(_ sender: UIButton) {
        if let _ = myBlock {
            myBlock(!myButton.isSelected,sender.tag)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
