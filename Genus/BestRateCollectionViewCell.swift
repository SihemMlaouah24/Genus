//
//  BestRateCollectionViewCell.swift
//  Genus
//
//  Created by Nazli on 12/10/20.
//

import UIKit

protocol collectionViewCellClicked3:class{
    func cellClicked(idGame:Int)
}

class BestRateCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var gamePicture: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var companyName: UILabel!
      

}
