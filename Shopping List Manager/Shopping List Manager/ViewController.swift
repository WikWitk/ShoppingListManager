//
//  ViewController.swift
//  Shopping List Manager
//
//  Created by Wiktor Witkowski on 28/11/2023.
//

import UIKit
import Firebase
import FirebaseAuth



class ViewController: UIViewController {

   
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var emlTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    
   
    @IBAction func sInBtn(_ sender: Any) {
        
        
        if emlTxt.text != "" && passTxt.text != nil {
            
            Auth.auth().signIn(withEmail: emlTxt.text!, password: passTxt.text!) { (authdata, error) in
                if error != nil {
                    self.makeAlert(titInput: "Error", messInput: error?.localizedDescription ?? "Error")
                    
                }else {
                    
                    self.performSegue(withIdentifier: "toList", sender: nil)
                    
                    
                }
                
            }
            
           
        }else{
            
            makeAlert(titInput: "Error", messInput: "Missing email or password!")
            
        }
        
        
        
        
    }
    
    @IBAction func sUpBtn(_ sender: Any) {
        
        if emlTxt.text != "" && passTxt.text != "" {
            
            Auth.auth().createUser(withEmail: emlTxt.text!, password: passTxt.text!) { (authdata,  error ) in
                
                if error != nil {
                    self.makeAlert(titInput: "Error", messInput: error?.localizedDescription ?? "Error")
                    
                }else{
                    self.performSegue(withIdentifier: "toList", sender: nil)
                    
                }
            }
            
        } else{
            
          makeAlert(titInput: "Error", messInput: "Missing email or password!")
        }
        
        
        
        
        
    }
    func makeAlert(titInput: String, messInput: String){
        
        let errorAlert = UIAlertController(title: titInput, message: messInput, preferredStyle: UIAlertController.Style.alert)
        let okBtn = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        errorAlert.addAction(okBtn)
        self.present(errorAlert, animated: true, completion: nil)
        
        
    }
    
    
    
    
}

