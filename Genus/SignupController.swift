//
//  SignupController.swift
//  Genus
//
//  Created by Orionsyrus24 on 11/24/20.
//


import UIKit

class SignupController: UIViewController {
    
    //Widgets
    
   
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var cPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    //Functions
    func alertErrorSignup(message: String, title: String ) {
           let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
           let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
           alertController.addAction(OKAction)
           self.present(alertController, animated: true, completion: nil)
         }
    
    
    
    
    func alertSignUp(message: String, title: String ) {
           let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
           let OKAction = UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginController") as! LoginController
            self.navigationController?.pushViewController(vc, animated: true)
            self.present(vc, animated: true, completion: nil)
            
           })
           alertController.addAction(OKAction)
           self.present(alertController, animated: true, completion: nil)
         }
    
    
    
    //IBActions
    
    @IBAction func registerAction(_ sender: Any) {
        if(email.text=="" || username.text=="" || password.text=="" || cPassword.text=="")
        {
            alertErrorSignup(message: "Please fill in all the fields !", title: "Warning")
        }
        else if (email.text!.contains("@")==false)
        {
            alertErrorSignup(message: "the email address is not correct !", title: "Warning")

        }
        else if (password.text == cPassword.text ) {
        
            let params = ["username":username.text,"email":email.text, "password":password.text] as! Dictionary<String, String>
            var request = URLRequest(url: URL(string: "http://192.168.64.1:3000/register")!)
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
            let responseData = String(data: data!, encoding: String.Encoding.utf8)
           
        
            
            DispatchQueue.main.async {
               
                let msg="Register successful"
                let res = responseData!.replacingOccurrences(of: "\"", with: "")
                if(res.caseInsensitiveCompare(msg) == .orderedSame) {
                self.alertSignUp(message:res,title:"Information")
                
                
               }
                else {
                    self.alertErrorSignup(message:res,title:"Error")
               }
            }
            
            })
            
         
            task.resume()
        
        
        }
        else
        {
        alertErrorSignup(message: "Both password fields should contain same password", title: "Warning")
        }
        
    }
    
}
