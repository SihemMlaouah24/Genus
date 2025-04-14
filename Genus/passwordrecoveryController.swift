//
//  passwordrecoveryController.swift
//  Genus
//
//  Created by Orionsyrus24 on 11/24/20.
//

import UIKit

class passwordrecoveryController: UIViewController {
    
    //Widgets
    
    @IBOutlet weak var email: UITextField!
    
    //Functions
    func alertErrorPassword(message: String, title: String ) {
           let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
           let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
           alertController.addAction(OKAction)
           self.present(alertController, animated: true, completion: nil)
         }
    
    
    func alertPasswordRecovery(message: String, title: String ) {
           let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
           let OKAction = UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginController") as! LoginController
            self.navigationController?.pushViewController(vc, animated: true)
            self.present(vc, animated: true, completion: nil)
            
           })
           alertController.addAction(OKAction)
           self.present(alertController, animated: true, completion: nil)
         }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    //IBActions
    
  
    @IBAction func sendAction(_ sender: Any) {
        if(email.text=="")
        {
            alertErrorPassword(message: "Please give your email", title: "Warning")
        }
        else if (email.text!.contains("@")==false)
        {
            alertErrorPassword(message: "the email address is not correct !", title: "Warning")

        }
        else {
    let params = ["email":email.text] as! Dictionary<String, String>
    var request = URLRequest(url: URL(string: "http://192.168.64.1:3000/getForgottenPassword")!)
    request.httpMethod = "PUT"
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
           
            let msg="Check your mail and get your code !"
            let res = responseData!.replacingOccurrences(of: "\"", with: "")
            if(res.caseInsensitiveCompare(msg) == .orderedSame) {
            self.alertPasswordRecovery(message:res,title:"Information")
            
            
           }
            else {
                self.alertErrorPassword(message:res,title:"Error")
           }
        }
        
    })
    
    task.resume()
        }
    }
}
