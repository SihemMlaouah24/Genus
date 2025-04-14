//
//  AllGamesTableViewCell.swift
//  Genus
//
//  Created by Orionsyrus24 on 1/11/21.
//

import UIKit

struct AllGames :Decodable{
    let idGame:Int
    let name:String
    let companyName:String
    let description:String
    let releaseDate:String
    let gamePicture:String
    let rating:Int
    let type:String
}

class AllGamesTableViewCell: UITableViewCell {
    
    //var
    
    var allGames=[AllGames]()
    
    //Widgets
   
    var delegate: collectionViewCellClicked4?
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
         getAllGames()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}



extension AllGamesTableViewCell:UICollectionViewDelegate,UICollectionViewDataSource {
    
   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return allGames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

            let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "AllGamesCell", for: indexPath) as! AllGamesCollectionViewCell
            cell.name.text=allGames[indexPath.row].name
            cell.companyName.text=allGames[indexPath.row].companyName
            cell.gamePicture.contentMode = .scaleAspectFill
        
                let defaultLink = "http://192.168.64.1:3000/image/"+allGames[indexPath.row].gamePicture
          // let defaultLink = "http://192.168.247.1:3000/image/"+topPicks[indexPath.row].gamePicture
            cell.gamePicture.downloaded(from: defaultLink)
            
            return cell
 
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
  
        delegate?.cellClicked(idGame: allGames[indexPath.row].idGame)
      
    }
    
    func getAllGames() {
     let url=URL(string: "http://192.168.64.1:3000/GetGames")
    //let url = URL(string: "http://192.168.247.1:3000/GetGames")
         
         URLSession.shared.dataTask(with: url!) { (data, response, error) in
             
                 if (error==nil) {
                 do {
                 self.allGames = try JSONDecoder().decode([AllGames].self, from: data!)
                    
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
