//
//  Server+CoreDataProperties.swift
//  Cleverdesk
//
//  Created by Matthias Kremer on 28.06.16.
//  Copyright © 2016 Cleverdesk. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Server {

    @NSManaged var url: String?
    @NSManaged var version: String?
    @NSManaged var users: User?

}
