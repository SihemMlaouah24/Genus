//
//  LoginController.swift
//  Genus
//
//  Created by Orionsyrus24 on 11/24/20.
//


import UIKit
import Alamofire
class LoginController: UIViewController {
    

    //Widgets

    @IBOutlet weak var email: UITextField! 
    
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    //Functions
    func alert(message: String, title: String ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
           }
        
         
    

    
    //IBActions
    
    @IBAction func LoginAction(_ sender: Any) {
        if(email.text=="" || password.text=="")
        {
            alert(message: "Please give your email and password", title: "Warning")
        }
        else if (email.text!.contains("@")==false)
        {
            alert(message: "the email address is not correct !", title: "Warning")

        }
        
     
        else {
    let params = ["email":email.text, "password":password.text] as! Dictionary<String, String>
    var request = URLRequest(url: URL(string: "http://192.168.64.1:3000/login")!)
    //var request = URLRequest(url: URL(string: "http://192.168.247.1:3000/login")!)
            
    request.httpMethod = "POST"
    request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    let session = URLSession.shared
    let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
    let error1="Wrong password"
    let error2="User doesnt exist !"
    let responseData = String(data: data!, encoding: String.Encoding.utf8)
    let res = responseData!.replacingOccurrences(of: "\"", with: "")
    if(res.caseInsensitiveCompare(error1) == .orderedSame || res.caseInsensitiveCompare(error2) == .orderedSame) {
   
        DispatchQueue.main.async {
       
            self.alert(message: res, title: "Error")
        }
    }
    else {
    do {
               
let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
        let name = json["username"] as! String
        let idUser=json["idUser"] as! Int
        let userPicture=json["userPicture"] as! String
        let alertController = UIAlertController(title: "Information", message: "Welcome you are connected !", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        { action -> Void in
     
          
                
    
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabController") as! MainTabController
            vc.Username=name
            vc.id=idUser
           vc.userPic=userPicture
            
            // This is to get the SceneDelegate object from your view controller
            // then call the change root view controller function to change to main tab bar
            if #available(iOS 13.0, *) {
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
            } else {
                // Fallback on earlier versions
            }
            
         /*    self.navigationController?.pushViewController(vc, animated: true)
             self.present(vc, animated: true, completion: nil)*/
           
            
        }
        alertController.addAction(OKAction)
        DispatchQueue.main.async {
        self.present(alertController, animated: true, completion: nil)
        }
                           
    }
   
    catch {
                        
    }
                
    }
    })
    
    task.resume()
    }
    }
        
    @IBAction func JoinAction(_ sender: Any) {
    
    }
    
    
    @IBAction func forgotPasswordAction(_ sender: Any) {
    }
    
    
    @IBAction func goTwitterAction(_ sender: Any) {
    }


    @IBAction func goFacebookAction(_ sender: Any) {
    }
    

    @IBAction func goInstagramAction(_ sender: Any) {
    }
}

