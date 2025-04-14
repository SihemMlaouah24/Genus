//
//  AllGamesCollectionViewCell.swift
//  Genus
//
//  Created by Orionsyrus24 on 1/11/21.
//

import UIKit

protocol collectionViewCellClicked4:class{
    func cellClicked(idGame:Int)
}

class AllGamesCollectionViewCell: UICollectionViewCell {
    
    
    
    @IBOutlet weak var gamePicture: UIImageView!
    
    
    @IBOutlet weak var name: UILabel!
    
    
    @IBOutlet weak var companyName: UILabel!
    
}
