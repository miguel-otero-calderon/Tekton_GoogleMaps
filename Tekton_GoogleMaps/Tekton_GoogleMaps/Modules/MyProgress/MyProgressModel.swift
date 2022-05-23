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
        
        init(timer: String, source: String, target: String, distance: String) {
            self.timer = timer
            self.source = source
            self.target = target
            self.distance = distance
        }
        
        init(route: MapViewModel.Route) {
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
