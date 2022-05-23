//
//  CoreDataModel.swift
//  Tekton_GoogleMaps
//
//  Created by Miguel on 22/05/22.
//

import Foundation

struct CoreDataModel {
    struct Route {
        let id:String
        let sourceLatitude: Double
        let sourcelongitude: Double
        let sourceAddress: String
        let destinationLatitude: Double
        let destinationLongitude: Double
        let destinationAddress: String
        let timerHours:Int
        let timerMinutes:Int
        let timerSeconds:Int
    }
}
