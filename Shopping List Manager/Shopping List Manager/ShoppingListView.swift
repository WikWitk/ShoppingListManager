//
//  ShoppingListView.swift
//  Shopping List Manager
//
//  Created by Wiktor Witkowski on 28/11/2023.
//

import UIKit
import Firebase
class ShoppingListView: UIViewController,UITableViewDelegate,UITableViewDataSource {


    @IBOutlet weak var listView: UITableView!
//    var usrEmailArray = [String]()
    var typeArray = [String]()
    var nameArray = [String]()
    var priceArray = [String]()
    var amountArray = [String]()
    var finalCostArray = [String]()
    var documentIDArray = [String]()
    var deletedItems: [String: [String: Any]] = [:]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listView.delegate = self
        listView.dataSource = self
        
     
        
        getDataFromFirestore()
        // Do any additional setup after loading the view.
    }
    
    func getDataFromFirestore(){
        let firestoreData = Firestore.firestore()
        
        firestoreData.collection("Lists").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription)
            }else{
                if snapshot?.isEmpty != true && snapshot != nil {
                    self.typeArray.removeAll(keepingCapacity: false)
                    self.nameArray.removeAll(keepingCapacity: false)
                    self.priceArray.removeAll(keepingCapacity: false)
                    self.amountArray.removeAll(keepingCapacity: false)
                    self.finalCostArray.removeAll(keepingCapacity: false)
                    self.documentIDArray.removeAll(keepingCapacity: false)
                    
                    
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        self.documentIDArray.append(documentID)
                        
                        
                        if let type = document.get("type") as? String {
                            self.typeArray.append(type)
                        }
                        if let name = document.get("name") as? String {
                            self.nameArray.append(name)
                        }
                        if let amount = document.get("amount") as? String {
                            self.amountArray.append(amount)
                        }
                        if let price = document.get("price") as? String {
                            self.priceArray.append(price)
                        }
                        if let finalCost = document.get("finalCost") as? String {
                            self.finalCostArray.append(finalCost)
                        }
                        
                        self.listView.reloadData()
                    }
                    
                }
                
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listView.dequeueReusableCell(withIdentifier: "toCell", for: indexPath) as! TableViewCell
        cell.nameLbl.text = "Name: \(nameArray[indexPath.row])"
        cell.amountLbl.text = "Amount: \(amountArray[indexPath.row])"
        cell.priceLbl.text = "Price: \(priceArray[indexPath.row])"
        cell.finalCostLbl.text = "Final Cost: \(finalCostArray[indexPath.row])"
        cell.typeLbl.text = "Type: \(typeArray[indexPath.row])"


        
        cell.mySwitch.isOn = false
        cell.mySwitch.addTarget(self, action: #selector(didChangeSwitch), for: .valueChanged)
        
        
        return cell
    }
    
    @objc func didChangeSwitch(_sender: UISwitch){
        let index = _sender.tag
        let documentID = documentIDArray[index]
        
        if _sender.isOn {
               // Remove the item from the Firebase database
               let firestoreData = Firestore.firestore()
               let listReference = firestoreData.collection("Lists").document(documentID)

               listReference.delete { error in
                   if let error = error {
                       print("Błąd podczas usuwania dokumentu: \(error.localizedDescription)")
                   } else {
                       print("Dokument został pomyślnie usunięty z bazy danych Firebase.")
                       
                       // Store information about the deleted item in the DeletedItems collection
                       let deletedItem = [
                        "type": self.typeArray[index],
                        "name": self.nameArray[index],
                        "amount": self.amountArray[index],
                        "price": self.priceArray[index],
                        "finalCost": self.finalCostArray[index]
                       ] as [String: Any]

                       let deletedItemsReference = firestoreData.collection("DeletedItems").document(documentID)

                       deletedItemsReference.setData(deletedItem) { error in
                           if let error = error {
                               print("Error when saving the data of a deleted item: \(error.localizedDescription)")
                           } else {
                               print("The data of the deleted item has been successfully saved in the Firebase database.")
                           }
                       }

                       // Refresh data after deletion
                       self.getDataFromFirestore()
                   }
               }
           } else {
               // Restore an item in Firebase
               let firestoreData = Firestore.firestore()
               let listReference = firestoreData.collection("Lists").document(documentID)

               listReference.setData([
                "type": self.typeArray[index],
                "name": self.nameArray[index],
                "amount": self.amountArray[index],
                "price": self.priceArray[index],
                "finalCost": self.finalCostArray[index]
               ]) { error in
                   if let error = error {
                       print("Błąd podczas przywracania dokumentu: \(error.localizedDescription)")
                   } else {
                       print("Dokument został pomyślnie przywrócony w bazie danych Firebase.")
                       
                       // Remove information about the deleted item from the DeletedItems collection
                       let deletedItemsReference = firestoreData.collection("DeletedItems").document(documentID)
                       deletedItemsReference.delete { error in
                           if let error = error {
                               print("Błąd podczas usuwania informacji o usuniętym elemencie: \(error.localizedDescription)")
                           } else {
                               print("Informacje o usuniętym elemencie zostały pomyślnie usunięte.")
                           }
                       }

                       //Refresh data after restoration
                       self.getDataFromFirestore()
                   }
               }
           }
       }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }


}
