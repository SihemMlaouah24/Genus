//
//  GameController.swift
//  Genus
//
//  Created by Orionsyrus24 on 11/24/20.
//

import UIKit
import Alamofire

struct  commentaire :Decodable {
    
    let idComment:Int
    let commentText:String
    let likesNbr:Int
    let userPicture:String
    let username:String
}

class GameController: UIViewController, UICollectionViewDataSource {
        
  //var
    var idGame:Int = 0
    var idUser:Int = 0
    var comments = [commentaire]()
    
    var gamePicture :  String = ""
    var gamename :  String = ""
    var gamestudio : String = ""
    var gameDesc : String = ""
    var rate : Int = 0
    
    
    
    
    //Widgets
   
    @IBOutlet weak var gamePic: UIImageView!
    @IBOutlet weak var gameBg: UIImageView!
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var gameStudio: UILabel!
    @IBOutlet weak var favNbr: UILabel!
    @IBOutlet weak var commentNbr: UILabel!
    @IBOutlet weak var gameDescription: UITextView!
    @IBOutlet weak var addGamelist: UIButton!
    @IBOutlet weak var addFavlist: UIImageView!
    @IBOutlet weak var addWishlist: UIImageView!
    @IBOutlet weak var comment: UITextField!
    @IBOutlet weak var sencCmnt: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var starOne: UIImageView!
    
    @IBOutlet weak var starTwo: UIImageView!
    
    @IBOutlet weak var starThree: UIImageView!
    
    
    @IBOutlet weak var starFour: UIImageView!
    
    
    @IBOutlet weak var starFive: UIImageView!
    
    
    @IBOutlet weak var addGamebutton: UIButton!
    override func viewDidLoad() {
        comment.text=""
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.dataSource=self
        if #available(iOS 13.0, *) {
            gameInformations(idGame: idGame)
        } else {
            // Fallback on earlier versions
        }
        GetComments(idGame: idGame)
        
        getCommentsNbr(idGame: idGame) { (nbr,error) in
            if let x = nbr {
                self.commentNbr.text="\(x)"
                
            }
        }
        
        getFavNbr(idGame: idGame) { (nbr,error) in
            if let x = nbr {
                self.favNbr.text="\(x)"
                
            }
        }
        
        ExisteFavList(idUser: idUser, idGame: idGame)
        
        ExisteWishList(idUser: idUser, idGame: idGame)
        
        ExisteGameList(idUser: idUser, idGame: idGame)
        
        if #available(iOS 13.0, *) {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            addFavlist.isUserInteractionEnabled = true
            addFavlist.addGestureRecognizer(tapGestureRecognizer)
        } else {
            // Fallback on earlier versions
        }
           
        
        if #available(iOS 13.0, *) {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            addWishlist.isUserInteractionEnabled = true
            addWishlist.addGestureRecognizer(tapGestureRecognizer)
        } else {
            // Fallback on earlier versions
        }

     
    }
    
    //Functions
    
    @available(iOS 13.0, *)
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView

        if (tappedImage.image==UIImage(systemName:"heart.fill")){
            deleteGameFromFavList(idGame: idGame,idUser: idUser)
            tappedImage.image=UIImage(systemName: "heart")
        }
        else  if (tappedImage.image==UIImage(systemName:"heart")) {
            addGameToFavList(idGame: idGame,idUser: idUser)
            tappedImage.image=UIImage(systemName: "heart.fill")
        }
        else if (tappedImage.image==UIImage(systemName:"pin.fill")){
            deleteGameFromWishList(idGame: idGame,idUser: idUser)
            tappedImage.image=UIImage(systemName: "pin")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
         
          
        }
        else  if (tappedImage.image==UIImage(systemName:"pin")) {
            addGameToWishList(idGame: idGame,idUser: idUser)
            tappedImage.image=UIImage(systemName: "pin.fill")
          
          
         
        }
    
    }
   
    func deleteGameFromWishList(idGame:Int,idUser:Int)
    {
        /*guard let url = URL(string: "http://192.168.247.1:3000/deleteFromWishList/"+"\(idGame)"+"/"+"\(idUser)") else {
         print("Error: cannot create URL")
         return
     }*/
        guard let url = URL(string: "http://192.168.64.1:3000/deleteFromWishList/"+"\(idGame)"+"/"+"\(idUser)") else {
                   print("Error: cannot create URL")
                   return
               }
               // Create the request
               var request = URLRequest(url: url)
               request.httpMethod = "DELETE"
               URLSession.shared.dataTask(with: request) { data, response, error in
                   guard error == nil else {
                       print("Error: error calling DELETE")
                       print(error!)
                       return
                   }
                   guard let data = data else {
                       print("Error: Did not receive data")
                       return
                   }
                   guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                       print("Error: HTTP request failed")
                       return
                   }
                   do {
                       guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                           print("Error: Cannot convert data to JSON")
                           return
                       }
                       guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                           print("Error: Cannot convert JSON object to Pretty JSON data")
                           return
                       }
                       guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                           print("Error: Could print JSON in String")
                           return
                       }
                       
                       print(prettyPrintedJson)
                   } catch {
                       print("Error: Trying to convert JSON data to string")
                       return
                   }
               }.resume()
    }
    func deleteGameFromFavList(idGame:Int,idUser:Int)
    {
        /*guard let url = URL(string: "http://192.168.247.1:3000/deleteFromFavList/"+"\(idGame)"+"/"+"\(idUser)") else {
         print("Error: cannot create URL")
         return
     }*/
        guard let url = URL(string: "http://192.168.64.1:3000/deleteFromFavList/"+"\(idGame)"+"/"+"\(idUser)") else {
                   print("Error: cannot create URL")
                   return
               }
               // Create the request
               var request = URLRequest(url: url)
               request.httpMethod = "DELETE"
               URLSession.shared.dataTask(with: request) { data, response, error in
                   guard error == nil else {
                       print("Error: error calling DELETE")
                       print(error!)
                       return
                   }
                   guard let data = data else {
                       print("Error: Did not receive data")
                       return
                   }
                   guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                       print("Error: HTTP request failed")
                       return
                   }
                   do {
                       guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                           print("Error: Cannot convert data to JSON")
                           return
                       }
                       guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                           print("Error: Cannot convert JSON object to Pretty JSON data")
                           return
                       }
                       guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                           print("Error: Could print JSON in String")
                           return
                       }
                       
                       print(prettyPrintedJson)
                   } catch {
                       print("Error: Trying to convert JSON data to string")
                       return
                   }
               }.resume()
    }
    func addGameToWishList(idGame:Int,idUser:Int)
    {
        let params = ["idUser":idUser, "idGame":idGame] as Dictionary<String, Any>
           // var request = URLRequest(url: URL(string: "http://192.168.247.1:3000/AddToWishList")!)
            var request = URLRequest(url: URL(string: "http://192.168.64.1:3000/AddToWishList")!)
            request.httpMethod = "POST"
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                        }
                        catch {
                    }
                DispatchQueue.main.async {
                 
                }
                })
                task.resume()
    }
    
    func addGameToFavList(idGame:Int,idUser:Int)
    {
        let params = ["idUser":idUser, "idGame":idGame] as Dictionary<String, Any>
           // var request = URLRequest(url: URL(string: "http://192.168.247.1:3000/AddToFavList")!)
            var request = URLRequest(url: URL(string: "http://192.168.64.1:3000/AddToFavList")!)
            request.httpMethod = "POST"
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                        }
                        catch {
                    }
                DispatchQueue.main.async {
                 
                }
                })
                task.resume()
    }
    
    func getFavNbr(idGame:Int,completionHandler: @escaping (String?,Error?)->
    Void) {
    let url=URL(string: "http://192.168.64.1:3000/GetFavoriteNbr/"+"\(idGame)")!
    let task = URLSession.shared.dataTask(with: url, completionHandler:{ data, response, error in guard let data = data else { return }
    do {
        let responseData = String(data: data, encoding: String.Encoding.utf8)
    let res = responseData!.replacingOccurrences(of: "\"", with: "")
    completionHandler(res,nil)
    }
    catch let parseErr {
    print(parseErr)
    
    }
    })
    task.resume()
    }
    
    func getCommentsNbr(idGame:Int,completionHandler: @escaping (String?,Error?)->
    Void) {
    let url=URL(string: "http://192.168.64.1:3000/GetCommentNbr/"+"\(idGame)")!
    let task = URLSession.shared.dataTask(with: url, completionHandler:{ data, response, error in guard let data = data else { return }
    do {
        let responseData = String(data: data, encoding: String.Encoding.utf8)
    let res = responseData!.replacingOccurrences(of: "\"", with: "")
    completionHandler(res,nil)
    }
    catch let parseErr {
    print(parseErr)
    
    }
    })
    task.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        comments.count
    }
    
  
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommentsCell", for: indexPath) as! CommentCollectionViewCell
        cell.userName.text=comments[indexPath.row].username
       cell.commentText.text=comments[indexPath.row].commentText
       cell.likesNbr.text="\(comments[indexPath.row].likesNbr)"
       
        let defaultLink = "http://192.168.64.1:3000/image/"+comments[indexPath.row].userPicture
       // let defaultLink = "http://192.168.247.1:3000/image/"+comments[indexPath.row].userPicture
     cell.userPic.downloaded(from: defaultLink)
        
      
        if #available(iOS 13.0, *) {
            cell.likeComment.addTarget(self, action: #selector(GameController.likeAComment(_:)), for:.touchUpInside)
        } else {
            // Fallback on earlier versions
        }
        cell.likeComment.tag = comments[indexPath.row].idComment
        return cell
    }
    
    @available(iOS 13.0, *)
    @objc func likeAComment(_ sender: UIButton) {
       
        let id = sender.tag
        
        let params = ["idComment":id] as [String : Any]
       // var request = URLRequest(url: URL(string: "http://192.168.247.1:3000/LikeComment")!)
        var request = URLRequest(url: URL(string: "http://192.168.64.1:3000/LikeComment")!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                do {
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                    }
                    catch {
                }
            DispatchQueue.main.async {
           
                self.viewDidLoad()
            }
            })
            task.resume()
            
        }
    
    
    func blurBgImage(image: UIImage) -> UIImage? {
            let radius: CGFloat = 20;
            let context = CIContext(options: nil);
            let inputImage = CIImage(cgImage: image.cgImage!);
            let filter = CIFilter(name: "CIGaussianBlur");
 
            filter?.setValue(inputImage, forKey: kCIInputImageKey);
            filter?.setValue("\(radius)", forKey:kCIInputRadiusKey);

            if let result = filter?.value(forKey: kCIOutputImageKey) as? CIImage{

                let rect = CGRect(origin: CGPoint(x: radius * 2,y :radius * 2), size: CGSize(width: image.size.width - radius * 4, height: image.size.height - radius * 4))

                if let cgImage = context.createCGImage(result, from: rect){
                    return UIImage(cgImage: cgImage);
                    }
            }
            return nil;
        }
    
    @available(iOS 13.0, *)
    func gameInformations (idGame:Int){
        

    var request = URLRequest(url: URL(string: "http://192.168.64.1:3000/GetGameDetailsiOS/"+"\(idGame)")!)
    //var request = URLRequest(url: URL(string: "http://192.168.247.1:3000/GetGameDetailsiOS/"+"\(idGame)")!)
            
    request.httpMethod = "GET"


    let session = URLSession.shared
    let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in

    do {
               
let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
        self.gamePicture = json["gamePicture"] as! String
        self.gamename = json["name"] as! String
        self.gamestudio = json["companyName"] as! String
        self.gameDesc = json["description"] as! String
        self.rate = json["rating"] as! Int
     
        
    }
   
    catch {
                        
    }
        
        DispatchQueue.main.async {
          //  let defaultLink = "http://192.168.247.1:3000/image/"+self.gamePicture
            let defaultLink = "http://192.168.64.1:3000/image/"+self.gamePicture
            let url = URL(string: "http://192.168.64.1:3000/image/"+self.gamePicture)
            let data = try? Data(contentsOf: url!)
            let image = UIImage(data: data!)
            self.gameBg.image = self.blurBgImage(image: image!)
            self.gamePic.downloaded(from: defaultLink)
            self.gameName.text = self.gamename
            self.gameStudio.text = self.gamestudio
            self.gameDescription.text = self.gameDesc
            if(self.rate==5)
            {
               
                self.starOne.image=UIImage(systemName:"star.fill")
               
                self.starTwo.image=UIImage(systemName:"star.fill")
                self.starThree.image=UIImage(systemName:"star.fill")
                self.starFour.image=UIImage(systemName:"star.fill")
                self.starFive.image=UIImage(systemName:"star.fill")
            }
            else if (self.rate==4) {
                self.starOne.image=UIImage(systemName:"star.fill")
                self.starTwo.image=UIImage(systemName:"star.fill")
                self.starThree.image=UIImage(systemName:"star.fill")
                self.starFour.image=UIImage(systemName:"star.fill")
            }
            else if (self.rate==3) {
                self.starOne.image=UIImage(systemName:"star.fill")
                self.starTwo.image=UIImage(systemName:"star.fill")
                self.starThree.image=UIImage(systemName:"star.fill")
            }
            else if (self.rate==2) {
                self.starOne.image=UIImage(systemName:"star.fill")
                self.starTwo.image=UIImage(systemName:"star.fill")
              
            }
            else if (self.rate==1)
            {
                self.starOne.image=UIImage(systemName:"star.fill")
               
            }
        }
    }
    )
    
    task.resume()
    
  
        
    }
    
    func GetComments (idGame:Int){
     
        let url=URL(string: "http://192.168.64.1:3000/GetCommentsiOS/"+"\(idGame)")
       // let url = URL(string: "http://192.168.247.1:3000/GetCommentsiOS/"+"\(idGame)")
  
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
        
            
            if (error==nil) {
            do {
               
                self.comments = try JSONDecoder().decode([commentaire].self, from: data!)
                
        
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


    //IBActions
    func ExisteGameList(idUser: Int,idGame: Int) {
 
        let url=URL(string: "http://192.168.64.1:3000/VerifyGamelist/"+"\(idUser)"+"/"+"\(idGame)")!
        //let url=URL(string:"http://192.168.247.1:3000/VerifyGamelist/"+"\(idUser)"+"/"+"\(idGame)")!
        let task = URLSession.shared.dataTask(with: url, completionHandler:{ data, response, error in guard let data = data else { return }
        do {
            let responseData = String(data: data, encoding: String.Encoding.utf8)
        let res = responseData!.replacingOccurrences(of: "\"", with: "")
            if(res.caseInsensitiveCompare("true") == .orderedSame ) {
                DispatchQueue.main.async {
                  
                    
                    self.addGamebutton.setTitle("Remove this game", for: .normal)
                }
                
            }
            else {
                self.addGamebutton.setTitle("Add this game", for: .normal)
            }
        }
        catch let parseErr {
        print(parseErr)
         
        }
        })
        task.resume()
       
    }
    
    //IBActions
    func ExisteFavList(idUser: Int,idGame: Int) {
 
        let url=URL(string: "http://192.168.64.1:3000/VerifyFavlist/"+"\(idUser)"+"/"+"\(idGame)")!
        //let url=URL(string:"http://192.168.247.1:3000/VerifyFavlist/"+"\(idUser)"+"/"+"\(idGame)")!
        let task = URLSession.shared.dataTask(with: url, completionHandler:{ data, response, error in guard let data = data else { return }
        do {
            let responseData = String(data: data, encoding: String.Encoding.utf8)
        let res = responseData!.replacingOccurrences(of: "\"", with: "")
            if(res.caseInsensitiveCompare("true") == .orderedSame ) {
                DispatchQueue.main.async {
                  
                    if #available(iOS 13.0, *) {
                        self.addFavlist.image=UIImage(systemName: "heart.fill")
                    } else {
                        // Fallback on earlier versions
                    }
                }
                
            }
            else {
                if #available(iOS 13.0, *) {
                    self.addFavlist.image=UIImage(systemName: "heart")
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        catch let parseErr {
        print(parseErr)
         
        }
        })
        task.resume()
       
    }
    
    //IBActions
    func ExisteWishList(idUser: Int,idGame: Int) {
 
        let url=URL(string: "http://192.168.64.1:3000/VerifyWishlist/"+"\(idUser)"+"/"+"\(idGame)")!
        //let url=URL(string:"http://192.168.247.1:3000/VerifyWishlist/"+"\(idUser)"+"/"+"\(idGame)")!
        let task = URLSession.shared.dataTask(with: url, completionHandler:{ data, response, error in guard let data = data else { return }
        do {
            let responseData = String(data: data, encoding: String.Encoding.utf8)
        let res = responseData!.replacingOccurrences(of: "\"", with: "")
            if(res.caseInsensitiveCompare("true") == .orderedSame ) {
                DispatchQueue.main.async {
                  
                    if #available(iOS 13.0, *) {
                        self.addWishlist.image=UIImage(systemName: "pin.fill")
                    } else {
                        // Fallback on earlier versions
                    }
                }
                
            }
            else {
                if #available(iOS 13.0, *) {
                    self.addWishlist.image=UIImage(systemName: "pin")
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        catch let parseErr {
        print(parseErr)
         
        }
        })
        task.resume()
       
    }
    
    @IBAction func addGameAction(_ sender: Any) {
        
        if(addGamebutton.titleLabel?.text=="Add this game")
        {
            addGameToList(idGame: idGame,idUser: idUser)
            addGamebutton.setTitle("Remove this game", for: .normal)
           
            
        }
        else
        {
            deleteGameFromList(idGame: idGame,idUser: idUser)
            addGamebutton.setTitle("Add this game", for: .normal)
           
        }
       
    }
    
    func deleteGameFromList(idGame:Int,idUser:Int)
    {
        /*guard let url = URL(string: "http://192.168.247.1:3000/deleteFromList/"+"\(idGame)"+"/"+"\(idUser)") else {
         print("Error: cannot create URL")
         return
     }*/
        guard let url = URL(string: "http://192.168.64.1:3000/deleteFromList/"+"\(idGame)"+"/"+"\(idUser)") else {
                   print("Error: cannot create URL")
                   return
               }
               // Create the request
               var request = URLRequest(url: url)
               request.httpMethod = "DELETE"
               URLSession.shared.dataTask(with: request) { data, response, error in
                   guard error == nil else {
                       print("Error: error calling DELETE")
                       print(error!)
                       return
                   }
                   guard let data = data else {
                       print("Error: Did not receive data")
                       return
                   }
                   guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                       print("Error: HTTP request failed")
                       return
                   }
                   do {
                       guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                           print("Error: Cannot convert data to JSON")
                           return
                       }
                       guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                           print("Error: Cannot convert JSON object to Pretty JSON data")
                           return
                       }
                       guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                           print("Error: Could print JSON in String")
                           return
                       }
                       
                       print(prettyPrintedJson)
                   } catch {
                       print("Error: Trying to convert JSON data to string")
                       return
                   }
               }.resume()
    }
    
    func addGameToList(idGame:Int,idUser:Int)
    {
        let params = ["idUser":idUser, "idGame":idGame] as Dictionary<String, Any>
           // var request = URLRequest(url: URL(string: "http://192.168.247.1:3000/AddToGameList")!)
            var request = URLRequest(url: URL(string: "http://192.168.64.1:3000/AddToGameList")!)
            request.httpMethod = "POST"
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                        }
                        catch {
                    }
                DispatchQueue.main.async {
                 
                }
                })
                task.resume()
    }
    
    func alert(message: String, title: String ) {
           let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
           let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
           alertController.addAction(OKAction)
           self.present(alertController, animated: true, completion: nil)
           }
    
 
    
    @IBAction func addCommentAction(_ sender: Any) {
        
        let params = ["commentText":comment.text!, "idUser":idUser, "idGame":idGame] as [String : Any]
       // var request = URLRequest(url: URL(string: "http://192.168.247.1:3000/AddComment")!)
        var request = URLRequest(url: URL(string: "http://192.168.64.1:3000/AddComment")!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                do {
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                    }
                    catch {
                }
            DispatchQueue.main.async {
           
                self.viewDidLoad()
            }
            })
            task.resume()
    }
}

