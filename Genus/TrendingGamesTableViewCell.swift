//
//  TrendingGamesTableViewCell.swift
//  Genus
//
//  Created by Orionsyrus24 on 1/8/21.
//

import UIKit

struct TrendingGames :Decodable{
    let idGame:Int
    let name:String
    let companyName:String
    let description:String
    let releaseDate:String
    let gamePicture:String
    let rating:Int
    let type:String
}

class TrendingGamesTableViewCell: UITableViewCell {
    
    //Var
    
    var trendingGames=[TrendingGames]()

    //Widgets
    var delegate: collectionViewCellClicked2?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        // Initialization code
        getTrendingGames()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


extension TrendingGamesTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return trendingGames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
            let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "TrendingGamesCell", for: indexPath) as! TrendingGamesCollectionViewCell
            cell.name.text=trendingGames[indexPath.row].name
            cell.companyName.text=trendingGames[indexPath.row].companyName
            cell.gamePicture.contentMode = .scaleAspectFill
           let defaultLink = "http://192.168.64.1:3000/image/"+trendingGames[indexPath.row].gamePicture
          // let defaultLink = "http://192.168.247.1:3000/image/"+trendingGames[indexPath.row].gamePicture
            cell.gamePicture.downloaded(from: defaultLink)
            
            return cell
        
        
    }
    
    
    
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           
    delegate?.cellClicked(idGame: trendingGames[indexPath.row].idGame)
            
        }
    
    
    func getTrendingGames() {
   let url=URL(string: "http://192.168.64.1:3000/GetTrendingGames")
  //let url = URL(string: "http://192.168.247.1:3000/GetTrendingGames")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
                if (error==nil) {
                do {
                    self.trendingGames = try JSONDecoder().decode([TrendingGames].self, from: data!)
                   
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
