//
//  Contact+CoreDataProperties.swift
//  
//
//  Created by CTIS Student on 31.12.2021.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var email: String?
    @NSManaged public var img: Data?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var name: String?
    @NSManaged public var note: String?
    @NSManaged public var number: Int64
    @NSManaged public var date: String?

}
