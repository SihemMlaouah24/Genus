//
//  WishListController.swift
//  Genus
//
//  Created by Orionsyrus24 on 12/8/20.
//

import UIKit

struct wishGame :Decodable{
    let idGame:Int
    let name:String
    let companyName:String
    let releaseDate:String
    let gamePicture:String
    let type:String
   
}



class WishListController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITabBarControllerDelegate {
    
    //Widgets
    
    @IBOutlet weak var collectionWish: UICollectionView!
    //Var
    var id:Int=0
    var games=[wishGame]()
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        collectionWish.dataSource=self
        collectionWish.allowsSelection = true
        collectionWish.delegate = self
    
        GetWishList(idUser:"\(id)")
     
      
    }
    
 
    //functions

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == self.collectionWish) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GameController") as! GameController
        vc.idUser=id
       
            vc.idGame=games[indexPath.row].idGame
      
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
   
 
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "wishlistCell", for: indexPath) as! WishlistCollectionViewCell
        cell.name.text=games[indexPath.row].name
        cell.companyName.text=games[indexPath.row].companyName
        cell.type.text=games[indexPath.row].type
        let index = games[indexPath.row].releaseDate.index(games[indexPath.row].releaseDate.startIndex, offsetBy: 10)
        let mySubstring = games[indexPath.row].releaseDate[..<index]
    cell.releaseDate.text=String(mySubstring)
        cell.gamePicture.contentMode = .scaleAspectFill
        let defaultLink = "http://192.168.64.1:3000/image/"+games[indexPath.row].gamePicture
        //let defaultLink = "http://192.168.247.1:3000/image/"+games[indexPath.row].gamePicture
        cell.gamePicture.downloaded(from: defaultLink)
        return cell
    }
             
    
    func GetWishList(idUser:String) {
    let url=URL(string: "http://192.168.64.1:3000/GetWishListIOS/"+idUser)
       
      //  let url=URL(string: "http://192.168.247.1:3000/GetWishListIOS/"+idUser)
      
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if (error==nil) {
            do {
            self.games=try JSONDecoder().decode([wishGame].self, from: data!)
               
            }
            catch {
            print("ERROR")
            }
            
            DispatchQueue.main.async {
              
                self.collectionWish.reloadData()
            }
        }
            
        }.resume()
   
    }    
    

    //IBActions
    
   
    @IBAction func searchAction(_ sender: Any) {
    }
}
