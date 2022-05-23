//
//  ViewController.swift
//  AhmadrezaSamiei_Project
//
//  Created by CTIS Student on 29.12.2021.
//  Copyright © 2021 CTIS. All rights reserved.
//

import UIKit
import CoreData
import Lottie

class MainVC: UIViewController {
    
    var mContact = [Contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readFromJson()
    }
    
    @IBAction func unwind(_ segue: UIStoryboardSegue) {}
    
    private func readFromJson(){
        if let path = Bundle.main.path(forResource: "data", ofType: "json") {
            if let jsonToParse = NSData(contentsOfFile: path) {
                
                guard let json = try? JSON(data: jsonToParse as Data) else {
                    print("Error with JSON")
                    return
                }
                
                let total = json["Contacts"].count
                for index in 0..<total {
                    if let name = json["Contacts"][index]["name"].string,
                        let number = json["Contacts"][index]["number"].int64,
                        let email = json["Contacts"][index]["email"].string,
                        let note = json["Contacts"][index]["note"].string,
                        let image = json["Contacts"][index]["img"].string,
                        let date = json["Contacts"][index]["date"].string,
                        let isFavorite = json["Contacts"][index]["isFavorite"].bool{
                        
                        let imageData = UIImage(named:image)!.jpegData(compressionQuality: 1)!
                        if someEntityExists(number: number) == false{
                            DBHelper.saveNewItem(name, number: number, email: email, date: date, note: note, img: imageData, isFavorite: isFavorite)
                        }
                        
                    }
                    else {
                        print("Error occurred during optional unwrapping")
                    }
                }
            }
            else {
                print("NSdata error")
            }
        }
        else {
            print("NSURL error")
        }
    }
    
    
    func someEntityExists(number: Int64) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        fetchRequest.predicate = NSPredicate(format: "number = %d", number)
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        var results: Any = []
        do {
            results = try context.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return (results as AnyObject).count > 0
    }
}


