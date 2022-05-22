//
//  MapViewModel.swift
//  Tekton_GoogleMaps
//
//  Created by Miguel on 22/05/22.
//

import Foundation
import CoreLocation

struct MapViewModel {
    struct Route {
        init(source: MapViewModel.Location, destination: MapViewModel.Location?) {
            self.id = getId()
            self.source = source
            self.destination = destination
        }
        
        let id:String
        let source: Location
        let destination: Location?
    }
    struct Location {
        let location: CLLocation
        let address: String
    }
}
