//
//  TopicsCollectionViewCell.swift
//  Genus
//
//  Created by Orionsyrus24 on 12/9/20.
//

import UIKit
class TopicsCollectionViewCell : UICollectionViewCell {
    
    
    //Widgets

    @IBOutlet weak var topicImage: UIImageView!
    
    @IBOutlet weak var topicName: UILabel!
    
    
    @IBOutlet weak var memberNumbers: UILabel!
    
    @IBOutlet weak var dateTopic: UILabel!


    @IBOutlet weak var topicCreator: UILabel!
    

    //Actions

    @IBOutlet weak var joinTopic: UIButton!
    
    @IBOutlet weak var deleteTopic: UIButton!
    
}
