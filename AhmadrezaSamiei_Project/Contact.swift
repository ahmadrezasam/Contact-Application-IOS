//
//  Contact+CoreDataClass.swift
//  
//
//  Created by CTIS Student on 31.12.2021.
//
//

import Foundation
import CoreData

@objc(Contact)
public class Contact: NSManagedObject {
    class func createInManagedObjectContext(_ context: NSManagedObjectContext, name: String, number: Int64, email: String, date: String, note: String, img: Data, isFavorite: Bool) -> Contact {
            let contactObject = NSEntityDescription.insertNewObject(forEntityName: "Contact", into: context) as! Contact
            contactObject.name = name
            contactObject.number = number
            contactObject.email = email
            contactObject.date = date
            contactObject.note = note
            contactObject.img = img
            contactObject.isFavorite = isFavorite

            return contactObject
    }
}
