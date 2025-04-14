//
//  BestRateTableViewCell.swift
//  Genus
//
//  Created by Orionsyrus24 on 1/8/21.
//

import UIKit


struct BestRate :Decodable{
    let idGame:Int
    let name:String
    let companyName:String
    let description:String
    let releaseDate:String
    let gamePicture:String
    let rating:Int
    let type:String
}


class BestRateTableViewCell: UITableViewCell {
    
    //Var
    var bestRate=[BestRate]()
    
    //Widgets
    
    var delegate: collectionViewCellClicked3?
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        // Initialization code
        getBestRateGames()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension BestRateTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
  
        return bestRate.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "BestRateCell", for: indexPath) as! BestRateCollectionViewCell
        cell.name.text=bestRate[indexPath.row].name
        cell.companyName.text=bestRate[indexPath.row].companyName
        cell.gamePicture.contentMode = .scaleAspectFill
        let defaultLink = "http://192.168.64.1:3000/image/"+bestRate[indexPath.row].gamePicture
      //  let defaultLink = "http://192.168.247.1:3000/image/"+bestRate[indexPath.row].gamePicture
        cell.gamePicture.downloaded(from: defaultLink)
        
        return cell
        
        
    }
    
    
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           
    delegate?.cellClicked(idGame: bestRate[indexPath.row].idGame)
            
        }
    
    func getBestRateGames() {
  let url=URL(string: "http://192.168.64.1:3000/GetBestRateGames")
//   let url = URL(string: "http://192.168.247.1:3000/GetBestRateGames")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
                if (error==nil) {
                do {
                self.bestRate = try JSONDecoder().decode([BestRate].self, from: data!)
                   
                }
                catch {
                print("ERROR")
                }
                
                DispatchQueue.main.async {
                  
                    self.collectionView.reloadData()
                }
            }
                
            }.resume()
    
    }
    
    
}
