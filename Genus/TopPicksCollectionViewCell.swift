//
//  TopPicksCollectionViewCell.swift
//  Genus
//
//  Created by Orionsyrus24 on 1/8/21.
//

import UIKit

protocol collectionViewCellClicked:class{
    func cellClicked(idGame:Int)
}

class TopPicksCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var gamePicture: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var companyName: UILabel!
}
