//
//  Contact+CoreDataProperties.swift
//  
//
//  Created by CTIS Student on 1.01.2022.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var date: String?
    @NSManaged public var email: String?
    @NSManaged public var img: Data?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var name: String?
    @NSManaged public var note: String?
    @NSManaged public var number: Int64

}
