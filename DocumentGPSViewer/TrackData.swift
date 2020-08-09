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

struct TrackData {
    let waypoints: [Data]
    let decodedWaypoints: [CLLocation]
    let totalDistanceCalc: CLLocationDistance
    let totalDurationCalc: DateInterval
    let averageSpeed: Speed
    let maxSpeed: Speed
    let mapRegion: MKCoordinateRegion
    let trackPolyline: MKPolyline
    var speedColoredWaypoints: [UIColor]
    var polylineLocations: [CGFloat]

    
    init(fileName: String, fileExtension: String) {
        let data = openFile(fileName: fileName, fileExtension: fileExtension)
        self.init(data: data!)
    }
    
    init(data: Data) {
        self.waypoints = SBPDataToWaypoints(fileData: data)
        self.decodedWaypoints = decodeWaypoints(waypoints: self.waypoints)
        self.totalDistanceCalc = totalDistance(waypoints: self.decodedWaypoints)
        self.totalDurationCalc = totalDuration(waypoints: self.decodedWaypoints)
        self.averageSpeed = Speed(speedMS: (totalDistanceCalc / totalDurationCalc.duration))
        self.maxSpeed = Speed(speedMS: maxSpeedInstant(waypoints: self.decodedWaypoints))
        self.mapRegion = trackMapRegion(waypoints: self.decodedWaypoints)
        self.trackPolyline = MKPolyline(coordinates: decodedWaypoints.map({$0.coordinate}), count: decodedWaypoints.count)
        
        self.speedColoredWaypoints = [UIColor]()
        self.polylineLocations = [CGFloat]()
        
        for i in 0..<self.decodedWaypoints.count {
            let wp = self.decodedWaypoints[i]
            let color = UIColor(red: CGFloat(wp.speed / self.maxSpeed.speedMS), green: CGFloat(1 - wp.speed / self.maxSpeed.speedMS), blue: 0.0, alpha: 1.0)
            self.speedColoredWaypoints.append(color)
             
            self.polylineLocations.append(self.trackPolyline.location(atPointIndex: i))
        }
        print(self.totalDistanceCalc)
    }
}

//let fileData = openFile(fileName: "20200703_Monteynard", fileExtension: "SBP")
//
//let waypointsData = SBPDataToWaypoints(fileData: fileData)
//
//let decodedWaypoints = decodeWaypoints(waypoints: waypointsData)
//
//let df = DateFormatter()
//df.dateFormat = "y-MM-dd H:m:ss.SSSS"
//
//for i in 100...400 {
//    print(df.string(from: decodedWaypoints[i].timestamp), "lat:", decodedWaypoints[i].coordinate.latitude, "lon:", decodedWaypoints[i].coordinate.longitude, "alt:", decodedWaypoints[i].altitude, "speed:", decodedWaypoints[i].speed*3.6)
//}
//
//let totalDistanceCalc = totalDistance(waypoints: decodedWaypoints)
//let totalDurationCalc = totalDuration(waypoints: decodedWaypoints)
//
//formatReadableDuration(duration: totalDurationCalc)
//
//let averageSpeed = totalDistanceCalc / totalDurationCalc.duration
//let averageSpeedKPH = averageSpeed * 3.6
//maxSpeedInstant(waypoints: decodedWaypoints)*3.6
//
//decodedWaypoints.count
