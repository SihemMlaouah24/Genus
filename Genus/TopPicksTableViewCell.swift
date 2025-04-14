//
//  TableViewCell.swift
//  Genus
//
//  Created by Orionsyrus24 on 1/8/21.
//

import UIKit

struct TopPicks :Decodable{
    let idGame:Int
    let name:String
    let companyName:String
    let description:String
    let releaseDate:String
    let gamePicture:String
    let rating:Int
    let type:String
}





class TopPicksTableViewCell: UITableViewCell {
    
    //var
    
    var topPicks=[TopPicks]()
  

    //Widgets
   
    var delegate: collectionViewCellClicked?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override  func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
         getTopPicks()
       
         
    }
    


}

extension TopPicksTableViewCell:UICollectionViewDelegate,UICollectionViewDataSource {
    
   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return topPicks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

            let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "topPicksCell", for: indexPath) as! TopPicksCollectionViewCell
            cell.name.text=topPicks[indexPath.row].name
            cell.companyName.text=topPicks[indexPath.row].companyName
            cell.gamePicture.contentMode = .scaleAspectFill
        
                let defaultLink = "http://192.168.64.1:3000/image/"+topPicks[indexPath.row].gamePicture
          // let defaultLink = "http://192.168.247.1:3000/image/"+topPicks[indexPath.row].gamePicture
            cell.gamePicture.downloaded(from: defaultLink)
            
            return cell
 
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
  
        delegate?.cellClicked(idGame: topPicks[indexPath.row].idGame)
      
    }
    
    func getTopPicks() {
     let url=URL(string: "http://192.168.64.1:3000/GetTopPicksGames")
    //let url = URL(string: "http://192.168.247.1:3000/GetTopPicksGames")
         
         URLSession.shared.dataTask(with: url!) { (data, response, error) in
             
                 if (error==nil) {
                 do {
                 self.topPicks = try JSONDecoder().decode([TopPicks].self, from: data!)
                    
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
