//
//  LibraryController.swift
//  Genus
//
//  Created by Orionsyrus24 on 11/24/20.
//


import UIKit

struct GameList :Decodable{
    let idGame : Int
    let name : String
    let companyName : String
    let releaseDate: String
    let gamePicture: String
    let type: String
   
}

struct FavGame :Decodable{
    let idGame : Int
    let name : String
    let companyName : String
    let releaseDate: String
    let gamePicture: String
    let type: String
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleToFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode =  .scaleToFill) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}



class LibraryController: UIViewController ,UICollectionViewDataSource, UICollectionViewDelegate{
  

    //Var 
    var id:Int=0
    var id2:Int=0
    
    //Widgets
 
    var games=[GameList]()
    var Favgames=[FavGame]()
    
    @IBOutlet weak var collectionViewGame: UICollectionView!
    @IBOutlet weak var collectionViewFavGame: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewGame.dataSource=self
        collectionViewFavGame.dataSource=self
        collectionViewGame.allowsSelection = true
        collectionViewFavGame.allowsSelection = true
        collectionViewGame.delegate = self
        collectionViewFavGame.delegate = self
        GetGameDetails(idUser:"\(id)")
        GetFavList(idUser:"\(id)")
    }

    
    //Function
    
    
    
    
    
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == self.collectionViewGame) {
            return games.count
            
        }
        else {
            return Favgames.count }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == self.collectionViewGame) {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "GameListCell", for: indexPath) as! GameListCollectionViewCell
        cell.companyName.text=games[indexPath.row].companyName
        cell.gameName.text=games[indexPath.row].name
        cell.gameType.text=games[indexPath.row].type
            cell.gameImage.contentMode = .scaleAspectFill
            let defaultLink = "http://192.168.64.1:3000/image/"+games[indexPath.row].gamePicture
           // let defaultLink = "http://192.168.247.1:3000/image/"+games[indexPath.row].gamePicture
            cell.gameImage.downloaded(from: defaultLink)
            let index = games[indexPath.row].releaseDate.index(games[indexPath.row].releaseDate.startIndex, offsetBy: 10)
            let mySubstring = games[indexPath.row].releaseDate[..<index]
        cell.releaseDate.text=String(mySubstring)
            
            return cell
        }
        else {
            let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "FavGameCell", for: indexPath) as! FavGameCollectionViewCell
            
            cell.companyName.text=Favgames[indexPath.row].companyName
            cell.gameName.text=Favgames[indexPath.row].name
            cell.gameImage.contentMode = .scaleAspectFill
            let defaultLink = "http://192.168.64.1:3000/image/"+Favgames[indexPath.row].gamePicture
           // let defaultLink = "http://192.168.247.1:3000/image/"+Favgames[indexPath.row].gamePicture
            cell.gameImage.downloaded(from: defaultLink)
            
            return cell
        }
        
    }
    

func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let vc = self.storyboard?.instantiateViewController(withIdentifier: "GameController") as! GameController
    vc.idUser=id
    if(collectionView == self.collectionViewFavGame) {
        vc.idGame=Favgames[indexPath.row].idGame
    }
    else {
        vc.idGame=games[indexPath.row].idGame
    }
    self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    func GetGameDetails(idUser:String) {
    let url=URL(string: "http://192.168.64.1:3000/GetGameListIOS/"+idUser)
   // let url = URL(string: "http://192.168.247.1:3000/GetGameListIOS/"+idUser)
    URLSession.shared.dataTask(with: url!) { (data, response, error) in
        
            if (error==nil) {
            do {
            self.games = try JSONDecoder().decode([GameList].self, from: data!)
               
            }
            catch {
            print("ERROR")
            }
            
            DispatchQueue.main.async {
              
                self.collectionViewGame.reloadData()
            }
        }
            
        }.resume()
        }
    
    
    
    
    
    
    
    
    func GetFavList(idUser:String) {
    let url=URL(string: "http://192.168.64.1:3000/GetFavListIOS/"+idUser)
   // let url=URL(string: "http://192.168.247.1:3000/GetFavListIOS/"+idUser)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
                if (error==nil) {
                do {
                self.Favgames = try JSONDecoder().decode([FavGame].self, from: data!)
                   
                }
                catch {
                print("ERROR")
                }
                
                DispatchQueue.main.async {
                  
                    self.collectionViewFavGame.reloadData()
                }
            }
                
            }.resume()
    }
    

    //IBActions
    
   
    @IBAction func searchAction(_ sender: Any) {
    }
}
