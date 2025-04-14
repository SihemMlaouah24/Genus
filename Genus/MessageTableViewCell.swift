//
//  MessageTableViewCell.swift
//  Genus
//
//  Created by Orionsyrus24 on 12/16/20.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        chatTextBubble.layer.cornerRadius = 12
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   
    @IBOutlet weak var msgTimeStack: UIStackView!
    
    @IBOutlet weak var usernamePicStack: UIStackView!
    
    
    
    @IBOutlet weak var chatTextBubble: UIView!
    
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var userPic: UIImageView!
    

    @IBOutlet weak var timeMSG: UILabel!
    
    
    @IBOutlet weak var userName: UILabel!
    
   
    
    @IBOutlet weak var msgContent: UITextView!
}
