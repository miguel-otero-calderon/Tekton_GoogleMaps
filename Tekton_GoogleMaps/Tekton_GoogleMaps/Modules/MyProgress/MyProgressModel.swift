//
//  MyProgressModel.swift
//  Tekton_GoogleMaps
//
//  Created by Miguel on 23/05/22.
//

import Foundation

struct MyProgressModel {
    struct CellData {
        let timer: String
        let source: String
        let target: String
        let distance: String
        let route: MapViewModel.Route
        
        init(route: MapViewModel.Route) {
            self.route = route
            if let timer = route.timer?.toString() {
                self.timer = timer
            } else {
                self.timer = ""
            }
            self.source = route.source.address
            if let target = route.destination?.address {
                self.target = target
            } else {
                self.target = ""
            }
            self.distance = route.getDistanceKmsString()
        }
    }
}
