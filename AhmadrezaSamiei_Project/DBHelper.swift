//
//  DBHelper.swift
//  AhmadrezaSamiei_Project
//
//  Created by CTIS Student on 1.01.2022.
//  Copyright © 2022 CTIS. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DBHelper{
    
    static func saveNewItem(_ name: String, number: Int64, email: String, date: String, note: String, img: Data, isFavorite: Bool) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let newContact = Contact.createInManagedObjectContext(context,
                                                            name: name, number: number, email: email, date: date, note: note, img: img, isFavorite: isFavorite)
        fetchData()
        save()
        //navigationController?.popViewController(animated: true)
    }
    
    
    
    static func save() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            try context.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    static func fetchData() {
        
        var mContact = [Contact]()

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")

        do {
            let results = try context.fetch(fetchRequest)
            type(of: results)
            mContact = results as! [Contact]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

}
