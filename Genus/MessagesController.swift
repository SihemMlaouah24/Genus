//
//  MessagesController.swift
//  Genus
//
//  Created by Orionsyrus24 on 12/16/20.
//

import UIKit
import SwiftWebSocket

struct Msg :Decodable{
    let idMessage : Int
    let contentMsg : String
    let date : String
    let idUser : Int
    let idChat : Int
    let username : String
    let userPicture : String
   
}



class MessagesController : UIViewController, UITableViewDelegate, UITableViewDataSource{
   
    //var
    
    var idChat:Int=0
    var msg=[Msg]()
    var id:Int=0
    var username:String=""
    var userPicture:String=""
    fileprivate let cellId="messagesCell"
    
    //Widgets

    
    
    
    @IBOutlet weak var messagesTableView: UITableView!
    
    
    @IBOutlet weak var msgToSend: UITextField!
    
    var socket : WebSocket!
    
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        
        socket = WebSocket("ws://192.168.64.1:3001")
        //socket = WebSocket("ws://192.168.247.1:3001")
        socket.event.open = {
            print("opened")
        }
         
        socket.event.close = { code, reason, clean in
            print("closed")
        }
         
        socket.event.error = { error in
            print("error \(error)")
        }
         
        socket.event.message = { message in
            if let text = message as? String {
                self.handleMessage(jsonString:text)
            }
        }
        socket.open()
        
        messagesTableView.dataSource=self
        messagesTableView.delegate=self
        messagesTableView.allowsSelection=false
     
        getMessages(idChat: idChat)
       
    }
    
 
        
    
    //Functions
    
    func handleMessage(jsonString:String){
        if let data = jsonString.data(using:String.Encoding.utf8){
            do {
                let JSON : [String:AnyObject] = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String : AnyObject]
                print("We've successfully parsed the message into a Dictionary! Yay!\n\(JSON)")
                let sender : String = JSON["name"] as! String
                let message : String = JSON["message"] as! String
                let time : String = JSON["time"] as! String
                let pic : String = JSON["pic"] as! String
                let id: Int = JSON["id"] as! Int
                let m = Msg (idMessage: 1, contentMsg: message, date: time, idUser: id, idChat: idChat, username: sender, userPicture: pic)
              
                msg.append(m)
                messagesTableView.reloadData()
                
                
                
            } catch let error{
                print("Error parsing json: \(error)")
            }
        }
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msg.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = messagesTableView.dequeueReusableCell(withIdentifier: cellId,for : indexPath) as! MessageTableViewCell
        cell.msgContent.text=msg[indexPath.row].contentMsg
       
        if(msg[indexPath.row].idUser==id) {
            cell.msgContent.textColor = .black
            cell.stack.alignment = .trailing
            cell.chatTextBubble.backgroundColor = UIColor.init(hexString: "#04D9D9")
        }
        else {
            cell.stack.alignment = .leading
            cell.chatTextBubble.backgroundColor = UIColor.init(hexString: "#111C59")
            cell.msgContent.textColor = .white
        }
        let index = msg[indexPath.row].date.index(msg[indexPath.row].date.startIndex, offsetBy: 5)
        let mySubstring = msg[indexPath.row].date[..<index]
        cell.timeMSG.text=String(mySubstring)
        cell.userName.text=msg[indexPath.row].username
        let defaultLink = "http://192.168.64.1:3000/image/"+msg[indexPath.row].userPicture
        cell.userPic.downloaded(from: defaultLink)
        return cell
    }
    
    
    func getMessages(idChat:Int)
    {
        var id="\(idChat)"
        let url=URL(string: "http://192.168.64.1:3000/ListMessages/"+id)
            
        // let url = URL(string: "http://192.168.247.1:3000/ListMessages/"+id)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
                if (error==nil) {
                do {
                self.msg = try JSONDecoder().decode([Msg].self, from: data!)
                   
                }
                catch {
                print("ERROR")
                }
                
                DispatchQueue.main.async {
                  
                    self.messagesTableView.reloadData()
                   
                }
            }
                
            }.resume()
    }
    
    
    
    
    @IBAction func sendMsg(_ sender: Any) {
        let msg=msgToSend.text
        var json = [String:AnyObject]()
        json["name"] = username as AnyObject
        json["message"] = msg as AnyObject?
        json["pic"] = userPicture as AnyObject
        json["id"] = id as AnyObject
        let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "HH:mm"
        json["time"] = dateFormatter.string(from: NSDate() as Date) as AnyObject
        
           do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted);
            if let string = String(data: jsonData, encoding: String.Encoding.utf8){
                   socket.send(string)
                    
               } else {
                   print("Couldn't create json string");
               }
           } catch let error {
               print("Couldn't create json data: \(error)");
           }
        
        let m = Msg (idMessage: 1, contentMsg: msg!, date: dateFormatter.string(from: NSDate() as Date) , idUser: id, idChat: idChat, username: username, userPicture: userPicture)
      
        self.msg.append(m)
        self.msgToSend.text=""
        self.messagesTableView.reloadData()
        
        let params = ["idUser":"\(id)", "contentMsg":msg,"idChat":"\(idChat)"] as! Dictionary<String, String>
        var request = URLRequest(url: URL(string: "http://192.168.64.1:3000/addMsg")!)
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
  
        
        })
        
     
        task.resume()
    
    
    }
    }
    

