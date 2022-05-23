//
//  RoutePersistence+CoreDataClass.swift
//  
//
//  Created by Miguel on 22/05/22.
//
//

import Foundation
import CoreData
import CoreLocation

@objc(RoutePersistence)
public class RoutePersistence: NSManagedObject {

    func toRoute() -> MapViewModel.Route? {
        guard let id = self.id else { return nil }
        guard let sourceAddress = self.sourceAddress else { return nil }
        guard let destinationAddress = self.destinationAddress else { return nil }
        
        let route = MapViewModel.Route(
            id: id,
            source: MapViewModel.Location(
                location: CLLocation( latitude: self.sourceLatitude,
                                      longitude: self.sourcelongitude),
                address: sourceAddress
            ),
            destination: MapViewModel.Location(
                location: CLLocation( latitude: self.destinationLatitude,
                                      longitude: self.destinationLongitude),
                address: destinationAddress
            ),
            timer: MapViewModel.Timer(
                hours: timerHours,
                minutes: timerMinutes,
                seconds: timerSeconds
            )
        )
        return route
    }
    
    func setRoute(route: MapViewModel.Route) {
        self.id =  route.id        
        self.sourceLatitude = route.source.location.coordinate.latitude
        self.sourcelongitude = route.source.location.coordinate.longitude
        self.sourceAddress = route.source.address
        self.destinationLatitude = route.destination?.location.coordinate.latitude ?? 0.00
        self.destinationLongitude = route.destination?.location.coordinate.longitude ?? 0.00
        self.destinationAddress = route.destination?.address ?? ""
        self.timerHours = route.timer?.hours ?? 0
        self.timerMinutes = route.timer?.minutes ?? 0
        self.timerSeconds = route.timer?.seconds ?? 0
    }
}
