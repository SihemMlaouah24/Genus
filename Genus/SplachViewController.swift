//
//  SplachViewController.swift
//  Genus
//
//  Created by Orionsyrus24 on 1/11/21.
//

import UIKit

let circlePathLayer = CAShapeLayer()
let circleRadius: CGFloat = 20.0






class SplachViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      configure()
    }

    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      configure()
    }

    func configure() {
      circlePathLayer.frame = bounds
      circlePathLayer.lineWidth = 2
      circlePathLayer.fillColor = UIColor.clear.cgColor
      circlePathLayer.strokeColor = UIColor.red.cgColor
      layer.addSublayer(circlePathLayer)
      backgroundColor = .white
    }

  

}
