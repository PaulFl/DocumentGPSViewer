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
    let decodedWaypoints: [[CLLocation]]
    var totalDistanceCalc: [CLLocationDistance]
    var totalDurationCalc: [DateInterval]
    var averageSpeed: [Speed]
    var maxSpeed: [Speed]
    var maxTack: [CLLocationDistance]
    var mapRegion: [MKCoordinateRegion]
    var trackPolyline: [MKPolyline]
    var speedColoredWaypoints: [[UIColor]]
    var polylineLocations: [[CGFloat]]

    
    init(fileName: String, fileExtension: String) {
        let data = openFile(fileName: fileName, fileExtension: fileExtension)
        self.init(data: data!)
    }
    
    init(data: Data) {
        self.waypoints = SBPDataToWaypoints(fileData: data)
        self.decodedWaypoints = decodeWaypoints(waypoints: self.waypoints)
        
        self.totalDistanceCalc = [CLLocationDistance]()
        self.totalDurationCalc = [DateInterval]()
        self.averageSpeed = [Speed]()
        self.maxSpeed = [Speed]()
        self.maxTack = [CLLocationDistance]()
        self.mapRegion = [MKCoordinateRegion]()
        self.trackPolyline = [MKPolyline]()
        self.speedColoredWaypoints = [[UIColor]]()
        self.polylineLocations = [[CGFloat]]()
        
        
        for wps in self.decodedWaypoints {
            let distance = totalDistance(waypoints: wps)
            let duration = totalDuration(waypoints: wps)
            let avgSpeed = Speed(speedMS: (distance / duration.duration))
            let maxSpeed = Speed(speedMS: maxSpeedInstant(waypoints: wps))
            let maxTack = maxTackDistance(waypoints: wps)
            let mapRegion = trackMapRegion(waypoints: wps)
            let trackPolyline = MKPolyline(coordinates: wps.map({$0.coordinate}), count: wps.count)
            
            var speedColoredWps = [UIColor]()
            var polylineLocations = [CGFloat]()
            
            for i in 0..<wps.count {
                let wp = wps[i]
                let color = UIColor(red: CGFloat(wp.speed / maxSpeed.speedMS), green: CGFloat(1 - wp.speed / maxSpeed.speedMS), blue: 0.0, alpha: 1.0)
                speedColoredWps.append(color)
                 
                polylineLocations.append(trackPolyline.location(atPointIndex: i))
            }

            self.totalDistanceCalc.append(distance)
            self.totalDurationCalc.append(duration)
            self.averageSpeed.append(avgSpeed)
            self.maxSpeed.append(maxSpeed)
            self.maxTack.append(maxTack)
            self.mapRegion.append(mapRegion)
            self.trackPolyline.append(trackPolyline)
            self.speedColoredWaypoints.append(speedColoredWps)
            self.polylineLocations.append(polylineLocations)
            
        }
    }
}
