//
//  TrackData.swift
//  GPSViewer
//
//  Created by Paul Fleury on 26/07/2020.
//

import Foundation
import MapKit

struct IdentifiableWaypoint: Identifiable {
    let id = UUID()
    let waypoint: CLLocation
    
    init(wp: CLLocation) {
        self.waypoint = wp
    }
}

struct Speed {
    let speedMS: CLLocationSpeed
    let speedKts: Double
    let speedKPH: Double
    
    init(speedMS: CLLocationSpeed) {
        self.speedMS = speedMS
        self.speedKts = speedMS * 1.94384
        self.speedKPH = speedMS * 3.6
    }
}

class TrackData {
    let waypoints: [Data]
    let decodedWaypoints: [[CLLocation]]
    var splitTracks: [SplitTrackData]

    convenience init(fileName: String, fileExtension: String) {
        let data = openFile(fileName: fileName, fileExtension: fileExtension)
        self.init(data: data!)
    }
    
    init(data: Data) {
        self.waypoints = SBPDataToWaypoints(fileData: data)
        self.decodedWaypoints = decodeWaypoints(waypoints: self.waypoints)
        
        self.splitTracks = [SplitTrackData]()
        
        for decodedWps in self.decodedWaypoints {
            self.splitTracks.append(SplitTrackData(decodedWaypoints: decodedWps))
        }
    }
}
