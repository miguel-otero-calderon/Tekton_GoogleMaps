//
//  RoutePersistence+CoreDataProperties.swift
//  
//
//  Created by Miguel on 22/05/22.
//
//

import Foundation
import CoreData


extension RoutePersistence {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RoutePersistence> {
        return NSFetchRequest<RoutePersistence>(entityName: "RoutePersistence")
    }

    @NSManaged public var id: String?
    @NSManaged public var sourceLatitude: Double
    @NSManaged public var sourcelongitude: Double
    @NSManaged public var sourceAddress: String?
    @NSManaged public var destinationLatitude: Double
    @NSManaged public var destinationLongitude: Double
    @NSManaged public var destinationAddress: String?
    @NSManaged public var timerSeconds: Int
    @NSManaged public var timerMinutes: Int
    @NSManaged public var timerHours: Int

}
