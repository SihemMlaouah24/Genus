//
//  ProfileController.swift
//  Genus
//
//  Created by Orionsyrus24 on 11/24/20.
//

import UIKit
import SCLAlertView


extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}

class MyTapGesture: UITapGestureRecognizer {
    var pic:String = ""
}

class ProfileController: UIViewController {
    
    //Widgets
    var id:Int=0
    var Username:String = "Full Name"
    var userPic:String = ""
    var gamesnbr: Any = 0
    var favnbr: Any  = 0
    var wishnbr: Any = 0
  
   
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var gameNbr: UILabel!
    
    @IBOutlet weak var favNbr: UILabel!
    
    @IBOutlet weak var wishNbr: UILabel!
    
    @IBOutlet weak var profilePic: UIImageView!
    
  
    
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        getGamesNbr(idUser:"\(id)") { (nbr,error) in
            if let x = nbr {
                self.gameNbr.text="\(x)"
                
            }
        }
        getFavNbr(idUser:"\(id)") { (nbr,error) in
            if let x = nbr {
                self.favNbr.text="\(x)"
                
            }
        }
        getWishNbr(idUser:"\(id)") { (nbr,error) in
            if let x = nbr {
                self.wishNbr.text="\(x)"
                
            }
        }
        // Do any additional setup after loading the view.
      username.text=Username
        let defaultLink = "http://192.168.64.1:3000/image/"+userPic
       // let defaultLink = "http://192.168.247.1:3000/image/"+userPic
        profilePic.downloaded(from: defaultLink)
    
       
    }
    
    //Functions

    func getGamesNbr(idUser:String,completionHandler: @escaping (String?,Error?)->
    Void) {
    let url=URL(string: "http://192.168.64.1:3000/GetGamesNbr/"+idUser)!
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
    
    func getFavNbr(idUser:String,completionHandler: @escaping (String?,Error?)->
    Void) {
    let url=URL(string: "http://192.168.64.1:3000/GetFavouriteGamesNbr/"+idUser)!
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
    
    
    func getWishNbr(idUser:String,completionHandler: @escaping (String?,Error?)->
    Void) {
    let url=URL(string: "http://192.168.64.1:3000/GetWishGamesNbr/"+idUser)!
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
    
  
    func alert(message: String, title: String ) {
           let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
           let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
           alertController.addAction(OKAction)
           self.present(alertController, animated: true, completion: nil)
           }
    
    
    @available(iOS 13.0, *)
    @objc func imageTapped(tapGestureRecognizer: MyTapGesture)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        userPic = tapGestureRecognizer.pic
        let id: String = "\(self.id)"
       
        let params = ["userPicture":userPic,"idUser": id] as! Dictionary<String, String>
var request = URLRequest(url: URL(string: "http://192.168.64.1:3000/editUserPicture")!)
request.httpMethod = "PUT"
request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
request.addValue("application/json", forHTTPHeaderField: "Content-Type")

let session = URLSession.shared
let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
        
        
    do {

            DispatchQueue.main.async {
              
                self.viewDidLoad()

            }
        
    }
    catch
    {
        
    }

})

task.resume()
    
        
    }
    
    
    //IBActions
    
    @IBAction func editProfileAction(_ sender: Any) {
   
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: true, titleColor: UIColor.init(hexString: "#04D9D9")
        )

        // Initialize SCLAlertView using custom Appearance
        let alert = SCLAlertView(appearance: appearance)

        // Creat the subview
        let subview = UIView(frame: CGRect(x:0,y:0,width:800,height:300))
       

        let image1 = UIImageView(frame: CGRect(x:0,y:30,width:70,height:70))
        image1.contentMode = .scaleAspectFill
        let defaultLink1 = "http://192.168.64.1:3000/image/avatar0.png"
       // let defaultLink = "http://192.168.247.1:3000/image/avatar0.png"
        image1.downloaded(from: defaultLink1)
        image1.layer.cornerRadius = 5
        subview.addSubview(image1)
        
        if #available(iOS 13.0, *) {
            let tapGestureRecognizer = MyTapGesture(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            tapGestureRecognizer.pic="avatar0.png"
            image1.isUserInteractionEnabled = true
            image1.addGestureRecognizer(tapGestureRecognizer)
  
           
        } else {
            // Fallback on earlier versions
        }
        
        
        
        
        
        let image2 = UIImageView(frame: CGRect(x:70,y:30,width:70,height:70))
        image2.contentMode = .scaleAspectFill
        let defaultLink2 = "http://192.168.64.1:3000/image/avatar1.png"
       // let defaultLink = "http://192.168.247.1:3000/image/avatar1.png"
        image2.downloaded(from: defaultLink2)
        image2.layer.cornerRadius = 5
        subview.addSubview(image2)
        
        if #available(iOS 13.0, *) {
            let tapGestureRecognizer = MyTapGesture(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            tapGestureRecognizer.pic="avatar1.png"
            image2.isUserInteractionEnabled = true
            image2.addGestureRecognizer(tapGestureRecognizer)
           
          
        } else {
            // Fallback on earlier versions
        }
        
        
        let image3 = UIImageView(frame: CGRect(x:140,y:30,width:70,height:70))
        image3.contentMode = .scaleAspectFill
        let defaultLink3 = "http://192.168.64.1:3000/image/avatar2.png"
       // let defaultLink = "http://192.168.247.1:3000/image/avatar2.png"
        image3.downloaded(from: defaultLink3)
        image3.layer.cornerRadius = 5
        subview.addSubview(image3)
        
        if #available(iOS 13.0, *) {
            let tapGestureRecognizer = MyTapGesture(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            tapGestureRecognizer.pic="avatar2.png"
            image3.isUserInteractionEnabled = true
            image3.addGestureRecognizer(tapGestureRecognizer)
       
        } else {
            // Fallback on earlier versions
        }
        
        
        let image4 = UIImageView(frame: CGRect(x:0,y:100,width:70,height:70))
        image4.contentMode = .scaleAspectFill
        let defaultLink4 = "http://192.168.64.1:3000/image/avatar3.png"
       // let defaultLink = "http://192.168.247.1:3000/image/avatar3.png"
        image4.downloaded(from: defaultLink4)
        image4.layer.cornerRadius = 5
        subview.addSubview(image4)
        
        
        if #available(iOS 13.0, *) {
            let tapGestureRecognizer = MyTapGesture(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            tapGestureRecognizer.pic="avatar3.png"
            image4.isUserInteractionEnabled = true
            image4.addGestureRecognizer(tapGestureRecognizer)
        
        } else {
            // Fallback on earlier versions
        }
        
        let image5 = UIImageView(frame: CGRect(x:70,y:100,width:70,height:70))
        image5.contentMode = .scaleAspectFill
        let defaultLink5 = "http://192.168.64.1:3000/image/avatar4.png"
       // let defaultLink = "http://192.168.247.1:3000/image/avatar4.png"
        image5.downloaded(from: defaultLink5)
        image5.layer.cornerRadius = 5
        subview.addSubview(image5)
        
        if #available(iOS 13.0, *) {
            let tapGestureRecognizer = MyTapGesture(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            tapGestureRecognizer.pic="avatar4.png"
            image5.isUserInteractionEnabled = true
            image5.addGestureRecognizer(tapGestureRecognizer)
       
        } else {
            // Fallback on earlier versions
        }
        
        
        let image6 = UIImageView(frame: CGRect(x:140,y:100,width:70,height:70))
        image6.contentMode = .scaleAspectFill
        let defaultLink6 = "http://192.168.64.1:3000/image/avatar5.png"
       // let defaultLink = "http://192.168.247.1:3000/image/avatar5.png"
        image6.downloaded(from: defaultLink6)
        image6.layer.cornerRadius = 5
        subview.addSubview(image6)
        
        if #available(iOS 13.0, *) {
            let tapGestureRecognizer = MyTapGesture(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            tapGestureRecognizer.pic="avatar5.png"
            image6.isUserInteractionEnabled = true
            image6.addGestureRecognizer(tapGestureRecognizer)
     
        } else {
            // Fallback on earlier versions
        }
        
        
        let image7 = UIImageView(frame: CGRect(x:0,y:170,width:70,height:70))
        image7.contentMode = .scaleAspectFill
        let defaultLink7 = "http://192.168.64.1:3000/image/avatar6.png"
       // let defaultLink = "http://192.168.247.1:3000/image/avatar6.png"
        image7.downloaded(from: defaultLink7)
        image7.layer.cornerRadius = 5
        subview.addSubview(image7)
        
        if #available(iOS 13.0, *) {
            let tapGestureRecognizer = MyTapGesture(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            tapGestureRecognizer.pic="avatar6.png"
            image7.isUserInteractionEnabled = true
            image7.addGestureRecognizer(tapGestureRecognizer)
    
        } else {
            // Fallback on earlier versions
        }
        
        
        let image8 = UIImageView(frame: CGRect(x:70,y:170,width:70,height:70))
        image8.contentMode = .scaleAspectFill
        let defaultLink8 = "http://192.168.64.1:3000/image/avatar7.png"
       // let defaultLink = "http://192.168.247.1:3000/image/avatar7.png"
        image8.downloaded(from: defaultLink8)
        image8.layer.cornerRadius = 5
        subview.addSubview(image8)
        
        if #available(iOS 13.0, *) {
            let tapGestureRecognizer = MyTapGesture(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            tapGestureRecognizer.pic="avatar7.png"
            image8.isUserInteractionEnabled = true
            image8.addGestureRecognizer(tapGestureRecognizer)
         
        } else {
            // Fallback on earlier versions
        }
        
        let image9 = UIImageView(frame: CGRect(x:140,y:170,width:70,height:70))
        image9.contentMode = .scaleAspectFill
        let defaultLink9 = "http://192.168.64.1:3000/image/avatar8.png"
       // let defaultLink = "http://192.168.247.1:3000/image/avatar8.png"
        image9.downloaded(from: defaultLink9)
        image9.layer.cornerRadius = 5
        subview.addSubview(image9)
        
        if #available(iOS 13.0, *) {
            let tapGestureRecognizer = MyTapGesture(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            tapGestureRecognizer.pic="avatar8.png"
            image9.isUserInteractionEnabled = true
            image9.addGestureRecognizer(tapGestureRecognizer)
       
        } else {
            // Fallback on earlier versions
        }
        
        let image10 = UIImageView(frame: CGRect(x:70,y:240,width:70,height:70))
        image10.contentMode = .scaleAspectFill
        let defaultLink10 = "http://192.168.64.1:3000/image/avatar9.png"
       // let defaultLink = "http://192.168.247.1:3000/image/avatar9.png"
        image10.downloaded(from: defaultLink10)
        image10.layer.cornerRadius = 5
        subview.addSubview(image10)
        
        if #available(iOS 13.0, *) {
            let tapGestureRecognizer = MyTapGesture(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            tapGestureRecognizer.pic="avatar9.png"
            image10.isUserInteractionEnabled = true
            image10.addGestureRecognizer(tapGestureRecognizer)
            
        } else {
            // Fallback on earlier versions
        }
        
        
    // Add the subview to the alert's UI property
    alert.customSubview = subview
    
    
    
   

   alert.showEdit("Pick up an avatar", subTitle:"", closeButtonTitle:"Close", timeout: nil,colorStyle: 0x04D9D9, colorTextButton: 0xFFFFFF, circleIconImage:UIImage(named:""), animationStyle:SCLAnimationStyle.noAnimation)
    }
    
    
 
    
    
    @IBAction func goMyAccountAction(_ sender: Any) {
        
        
    
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: true, titleColor: UIColor.init(hexString: "#04D9D9")
        )

        // Initialize SCLAlertView using custom Appearance
        let alert = SCLAlertView(appearance: appearance)

        // Creat the subview
        let subview = UIView(frame: CGRect(x:0,y:0,width:216,height:200))
        let x = (subview.frame.width - 180) / 2
     
        // Add textfield 2
        let textfield = UITextField(frame: CGRect(x:0,y:0,width:216,height:40))
        textfield.isSecureTextEntry=true
        textfield.layer.borderColor = UIColor.init(hexString: "#04D9D9").cgColor
        textfield.layer.borderWidth = 1.5
        textfield.layer.cornerRadius = 5
        textfield.placeholder = "old password"
        textfield.textAlignment = NSTextAlignment.center
        subview.addSubview(textfield)
        

        // Add textfield 2
        let textfield2 = UITextField(frame: CGRect(x:0,y:textfield.frame.maxY + 30,width:216,height:40))
        textfield2.isSecureTextEntry=true
        textfield2.layer.borderColor = UIColor.init(hexString: "#04D9D9").cgColor
        textfield2.layer.borderWidth = 1.5
        textfield2.layer.cornerRadius = 5
        textfield2.placeholder = "password"
        textfield2.textAlignment = NSTextAlignment.center
        subview.addSubview(textfield2)
        
        //Add textfield 3

        let textfield3 = UITextField(frame: CGRect(x:0,y:textfield2.frame.maxY + 30,width:216,height:40))
        textfield3.isSecureTextEntry=true
        textfield3.layer.borderColor = UIColor.init(hexString: "#04D9D9").cgColor
        textfield3.layer.borderWidth = 1.5
        textfield3.layer.cornerRadius = 5
        textfield3.placeholder = "confirm password"
        textfield3.textAlignment = NSTextAlignment.center
        subview.addSubview(textfield3)
        
        
        
        
        alert.addButton("Update password",backgroundColor: UIColor(hexString: "#04D9D9"),textColor: UIColor.white) {
        
            if(textfield.text=="" || textfield2.text=="" || textfield3.text=="")
            {
               
                    self.alert(message: "Please fill in all fields !", title: "Warning")
               
                
            }
          
            else if (textfield2.text==textfield3.text)
              
        
            {
                let id: String = "\(self.id)"
                let oldpassword=textfield.text
                let password=textfield2.text
                let params = ["old_password":oldpassword,"idUser": id, "new_password" :password] as! Dictionary<String, String>
        var request = URLRequest(url: URL(string: "http://192.168.64.1:3000/editPassword")!)
        request.httpMethod = "PUT"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                
                
            do {
       
                    DispatchQueue.main.async {
                   
                    let error1="Update failed"
                    let error2="User not found"
                    let error3="old password is wrong"
                    let responseData = String(data: data!, encoding: String.Encoding.utf8)
                    let res = responseData!.replacingOccurrences(of: "\"", with: "")
                    if(res.caseInsensitiveCompare(error1) == .orderedSame || res.caseInsensitiveCompare(error2) == .orderedSame || res.caseInsensitiveCompare(error3) == .orderedSame) {
                    self.alert(message:res,title:"Error")
                   
                    }
                    else {
                      
                        let alertController = UIAlertController(title: "Information", message: res, preferredStyle: .alert)
                        let OKAction = UIAlertAction(title: "OK", style: .default)
                        { action -> Void in
                        
                            
                        }
                        alertController.addAction(OKAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                        
          
               
                     
           
                    }
                }
            }
            catch
            {
                
            }

        })
        
        task.resume()
            }
        
                else {
                    self.alert(message: "Both passwords should be same", title: "Warning")
                }
   
       
        }
        
        
    
        // Add the subview to the alert's UI property
        alert.customSubview = subview
        
        
        
       

       alert.showEdit("Edit Profil", subTitle:"", closeButtonTitle:"Close", timeout: nil,colorStyle: 0x04D9D9, colorTextButton: 0xFFFFFF, circleIconImage:UIImage(named:""), animationStyle:SCLAnimationStyle.noAnimation)
    }
    
    
    @IBAction func nightModeAction(_ sender: Any) {
        self.alert(message: "Information", title: "Coming soon")
    }
    
    

    
    
    @IBAction func languageAction(_ sender: Any) {
        self.alert(message: "Information", title: "Coming soon")
    }
    
    
  
    
    
    @IBAction func signoutAction(_ sender: Any) {
        
    }
    
    
    @IBAction func editUsername(_ sender: Any) {
        
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
        let x = (subview.frame.width - 180) / 2
        // Add textfiel
        let textfield1 = UITextField(frame: CGRect(x:0,y:30,width:216,height:40))
        textfield1.layer.borderColor = UIColor.init(hexString: "#04D9D9").cgColor
        textfield1.layer.borderWidth = 1.5
        textfield1.layer.cornerRadius = 5
        textfield1.placeholder = "username"
        textfield1.textAlignment = NSTextAlignment.center
        subview.addSubview(textfield1)
        
        alert.addButton("Update Username",backgroundColor: UIColor(hexString: "#04D9D9"),textColor: UIColor.white) {
            if(textfield1.text=="")
            {
                self.alert(message: "Please give your username !", title: "Warning")
            }
            else {
                let id: String = "\(self.id)"
                let username=textfield1.text
                let params = ["username":username,"idUser": id] as! Dictionary<String, String>
        var request = URLRequest(url: URL(string: "http://192.168.64.1:3000/editUsername")!)
        request.httpMethod = "PUT"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                
                
            do {
       
                    DispatchQueue.main.async {
                   
                    let error1="Update failed"
                    let error2="User not found"
                    let responseData = String(data: data!, encoding: String.Encoding.utf8)
                    let res = responseData!.replacingOccurrences(of: "\"", with: "")
                    if(res.caseInsensitiveCompare(error1) == .orderedSame || res.caseInsensitiveCompare(error2) == .orderedSame) {
                    self.alert(message:res,title:"Error")
                   
                    }
                    else {
                      
                        let alertController = UIAlertController(title: "Information", message: res, preferredStyle: .alert)
                        let OKAction = UIAlertAction(title: "OK", style: .default)
                        { action -> Void in
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileController") as! ProfileController
                            vc.id=self.id
                            vc.Username=textfield1.text!
                            vc.userPic=self.userPic
                           
                           self.navigationController?.pushViewController(vc, animated: true)
                          
                            
                        }
                        alertController.addAction(OKAction)
                        
                        self.present(alertController, animated: true, completion: nil)
   
                    }
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
    
    
    
   

   alert.showEdit("Edit Username", subTitle:"", closeButtonTitle:"Close", timeout: nil,colorStyle: 0x04D9D9, colorTextButton: 0xFFFFFF, circleIconImage:UIImage(named:""), animationStyle:SCLAnimationStyle.noAnimation)
    }
    
}
