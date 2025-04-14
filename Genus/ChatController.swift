//
//  ChatController.swift
//  Genus
//
//  Created by Orionsyrus24 on 12/8/20.
//

import UIKit
import SCLAlertView

struct Chat :Decodable{
    let idChat : Int
    let topic : String
    let Date : String
    let username : String
}

class ChatController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate{
    

    //Widgets
    
    var chats=[Chat]()
    var id:Int=0
    var userPicture:String=""
    var username:String=""
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var addTopic: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        addTopic.layer.cornerRadius = 0.5 * addTopic.bounds.size.width
        addTopic.clipsToBounds = true
        collectionView.dataSource=self
        collectionView.delegate = self
        collectionView.allowsSelection = true
       

        GetChatList()

    }

    //Functions
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        chats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "topicCell", for: indexPath) as! TopicsCollectionViewCell
        cell.topicName.text=chats[indexPath.row].topic
        let index = chats[indexPath.row].Date.index(chats[indexPath.row].Date.startIndex, offsetBy: 10)
        let mySubstring = chats[indexPath.row].Date[..<index]
     
        cell.dateTopic.text=String(mySubstring)
        cell.topicCreator.text=chats[indexPath.row].username
        
        
        
        getMembersNbr(idChat: chats[indexPath.row].idChat) { (nbr,error) in
            if let x = nbr {
                cell.memberNumbers.text="Members : "+"\(x)"
                
            }
        }
        
        
        
        cell.joinTopic.addTarget(self, action: #selector(ChatController.joinThatTopic(_:)), for:.touchUpInside)
        cell.joinTopic.tag = chats[indexPath.row].idChat
        
        
        cell.deleteTopic.addTarget(self, action: #selector(ChatController.deleteThatTopic(_:)), for: .touchUpInside)
        
        cell.deleteTopic.tag = chats[indexPath.row].idChat
        
        return cell
    }


    
        
        func alert(message: String, title: String ) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
               }
        
        
        
    func getMembersNbr(idChat:Int,completionHandler: @escaping (String?,Error?)->
    Void) {
    let url=URL(string: "http://192.168.64.1:3000/GetMembersNbr/"+"\(idChat)")!
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
 
    @objc func deleteThatTopic(_ sender: UIButton) {
        let idTopic = sender.tag
        let url=URL(string:"http://192.168.64.1:3000/VerifyTopicCreator/"+"\(self.id)"+"/"+"\(idTopic)")!
        //let url=URL(string:"http://192.168.247.1:3000/VerifyTopicCreator/"+"\(id)"+"/"+"\(idTopic)")!
        let task = URLSession.shared.dataTask(with: url, completionHandler:{ data, response, error in guard let data = data else { return }
            do {
                let responseData = String(data: data, encoding: String.Encoding.utf8)
            let res = responseData!.replacingOccurrences(of: "\"", with: "")
                if(res.caseInsensitiveCompare("true") == .orderedSame ) {
                    DispatchQueue.main.async {
                      
                        /*guard let url = URL(string: "http://192.168.247.1:3000/deleteTopic/"+"\(idTopic)"+"/"+"\(id)") else {
                         print("Error: cannot create URL")
                         return
                     }*/
                        guard let url = URL(string: "http://192.168.64.1:3000/deleteTopic/"+"\(idTopic)"+"/"+"\(self.id)") else {
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
                        
                        self.viewDidLoad()
                    }
                    
                }
                else {
                    DispatchQueue.main.async {
                    self.alert(message: "You can't delete the topic , you're not the creator", title: "Error")
                    }
                }
            }
            catch  {
            
             
            }
            })
            task.resume()

        
    }
        
    @objc func joinThatTopic(_ sender: UIButton) {
       
        let idTopic = sender.tag
        let url=URL(string: "http://192.168.64.1:3000/verifyParticipation/"+"\(id)"+"/"+"\(idTopic)")!
        //let url=URL(string:"http://192.168.247.1:3000/verifyParticipation/"+"\(id)"+"/"+"\(idTopic)")!
        let task = URLSession.shared.dataTask(with: url, completionHandler:{ data, response, error in guard let data = data else { return }
        do {
            let responseData = String(data: data, encoding: String.Encoding.utf8)
        let res = responseData!.replacingOccurrences(of: "\"", with: "")
            if(res.caseInsensitiveCompare("true") == .orderedSame ) {
                DispatchQueue.main.async {
                  
                    print("User is participating already")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "MessagesController")as! MessagesController
                      vc.idChat=idTopic
                    vc.id=self.id
                    vc.username=self.username
                    vc.userPicture=self.userPicture
                       self.navigationController?.pushViewController(vc, animated: true)
                   
                }
                
            }
            else {
                let params = ["idUser":self.id, "idChat":idTopic] as Dictionary<String, Any>
                   // var request = URLRequest(url: URL(string: "http://192.168.247.1:3000/addParticipation")!)
                    var request = URLRequest(url: URL(string: "http://192.168.64.1:3000/addParticipation")!)
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
                            let alertController = UIAlertController(title: "Message", message: "Welcome to the party", preferredStyle: .alert)
                            let OKAction = UIAlertAction(title: "OK", style: .default)
                            { action -> Void in
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MessagesController")as! MessagesController
                                self.collectionView.reloadData()
                                  vc.idChat=idTopic
                                vc.id=self.id
                                vc.username=self.username
                                vc.userPicture=self.userPicture
                                   self.navigationController?.pushViewController(vc, animated: true)
                                
                            }
                            alertController.addAction(OKAction)
                            self.present(alertController, animated: true, completion: nil)
                           
                            
                        }
                        })
                        task.resume()
            }
        }
        catch let parseErr {
        print(parseErr)
         
        }
        })
        task.resume()
        
    }
    
    
    

    
    func GetChatList() {
    let url=URL(string: "http://192.168.64.1:3000/GetChatList")
    // let url = URL(string: "http://192.168.247.1:3000/GetChatList"))
    URLSession.shared.dataTask(with: url!) { (data, response, error) in
    
        if (error==nil) {
        do {
        self.chats = try JSONDecoder().decode([Chat].self, from: data!)
           
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
    
   
    @IBAction func searchAction(_ sender: Any) {
    }
    
    
    
    @IBAction func addTopic(_ sender: Any) {
        
            let appearance = SCLAlertView.SCLAppearance(
                kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
                kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
                kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
                showCloseButton: true, titleColor: UIColor.init(hexString: "#04D9D9")
            )

            // Initialize SCLAlertView using custom Appearance
            let alert = SCLAlertView(appearance: appearance)

            // Creat the subview
            let subview = UIView(frame: CGRect(x:0,y:0,width:216,height:100))
       
            // Add textfiel
            let textfield1 = UITextField(frame: CGRect(x:0,y:30,width:216,height:40))
            textfield1.layer.borderColor = UIColor.init(hexString: "#04D9D9").cgColor
            textfield1.layer.borderWidth = 1.5
            textfield1.layer.cornerRadius = 5
            textfield1.placeholder = "name a topic"
            textfield1.textAlignment = NSTextAlignment.center
            subview.addSubview(textfield1)
            
            alert.addButton("Add",backgroundColor: UIColor(hexString: "#04D9D9"),textColor: UIColor.white) {
                if(textfield1.text=="")
                {
                   self.alert(message: "Please give a topic name!", title: "Warning")
                }
                else {
                    let id: String = "\(self.id)"
                    let topic=textfield1.text
                    let params = ["topic":topic,"idUser": id] as! Dictionary<String, String>
            var request = URLRequest(url: URL(string: "http://192.168.64.1:3000/addTopic")!)
            request.httpMethod = "POST"
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                    
                    
                do {
           
                        DispatchQueue.main.async {
                       
                       
                          
                            let alertController = UIAlertController(title: "Message", message: "Topic added ! ", preferredStyle: .alert)
                            let OKAction = UIAlertAction(title: "OK", style: .default)
                            { action -> Void in
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileController") as! ProfileController
                                self.GetChatList()
                                
                            }
                            alertController.addAction(OKAction)
                            
                            self.present(alertController, animated: true, completion: nil)
       
                        }
                    }
                
                catch
                {
                    
                }

            })
            
            task.resume()
                }
            
                    
                }
   
  
            // Add the subview to the alert's UI property
            alert.customSubview = subview
            

           alert.showEdit("Add a topic", subTitle:"", closeButtonTitle:"Close", timeout: nil,colorStyle: 0x04D9D9, colorTextButton: 0xFFFFFF, circleIconImage:UIImage(named:""), animationStyle:SCLAnimationStyle.noAnimation)
    }
    
    
    
    
             
      
}
