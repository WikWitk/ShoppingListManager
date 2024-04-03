//
//  LogOutView.swift
//  Shopping List Manager
//
//  Created by Wiktor Witkowski on 28/11/2023.
//

import UIKit
import Firebase

class LogOutView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
        
        
        
        
    @IBAction func loggingOut(_ sender: Any) {
       
            self.performSegue(withIdentifier: "toLogin", sender: nil)
            
        }
    
    
    
}
