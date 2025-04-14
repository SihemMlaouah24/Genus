//
//  CommentCollectionViewCell.swift
//  Genus
//
//  Created by Nazli on 12/17/20.
//

import UIKit
class CommentCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var userPic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var commentText: UILabel!
    @IBOutlet weak var likesNbr: UILabel!
    
    
    @IBOutlet weak var likeComment: UIButton!
    
}
