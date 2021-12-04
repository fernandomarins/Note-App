//
//  Note.swift
//  Note App
//
//  Created by Fernando Marins on 03/12/21.
//

import CoreData

@objc(Note)
class Note: NSManagedObject {
    @NSManaged var id: NSNumber!
    @NSManaged var title: String!
    @NSManaged var desc: String!
    @NSManaged var deletedData: Date?
}

