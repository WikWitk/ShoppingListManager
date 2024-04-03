//
//  AddProductView.swift
//  Shopping List Manager
//
//  Created by Wiktor Witkowski on 28/11/2023.
//

import UIKit
import FirebaseFirestore


class AddProductView: UIViewController {

    @IBOutlet weak var fcTxt: UITextField!
    @IBOutlet weak var priceTxt: UITextField!
    @IBOutlet weak var amountTxt: UITextField!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var typTxt: UITextField!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        priceTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        amountTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        
       
        // Do any additional setup after loading the view.
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
           // Sprawdź, czy wartości w textField1 i textField2 są liczbami
           guard let value1 = Double(priceTxt.text ?? ""), let value2 = Double(amountTxt.text ?? "") else {
               fcTxt.text = "Błędne dane"
               return
           }

           // Przeprowadź mnożenie
           let result = value1 * value2

           // Wyświetl wynik w resultTextField
           fcTxt.text = String(result)
       }
    
    func makeAlert(titInput: String, messInput: String){
        let errorAlert = UIAlertController(title: titInput, message: messInput, preferredStyle: UIAlertController.Style.alert)
        let okBtn = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        errorAlert.addAction(okBtn)
        self.present(errorAlert, animated: true, completion: nil)
    }

   
    @IBAction func saveTxt(_ sender: Any) {
        
        if amountTxt.text == "" && nameTxt.text == "" && priceTxt.text == "" {
            makeAlert(titInput: "Error", messInput: "Please fill in missing gap")
            
            
        }else{
            
            let fireStoreDatabase = Firestore.firestore()
            var firestoreReferences : DocumentReference? = nil
            let firestoreList = ["type": typTxt.text!,"name": nameTxt.text!, "price": priceTxt.text!, "amount": amountTxt.text!, "finalCost": fcTxt.text!,
                                 "date":FieldValue.serverTimestamp()] as [String : Any]
            
            firestoreReferences = fireStoreDatabase.collection("Lists").addDocument(data: firestoreList, completion: { (error) in
                if error != nil{
                    self.makeAlert(titInput: "Error", messInput: error?.localizedDescription ?? "Error")
                }else {
                    self.tabBarController?.selectedIndex = 0
                    self.typTxt.text = ""
                    self.nameTxt.text = ""
                    self.amountTxt.text = ""
                    self.priceTxt.text = ""
                    self.fcTxt.text = ""
                    
                    
                }
            })
            
            
            
            
            
            
            
            
        }
    }
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
}
