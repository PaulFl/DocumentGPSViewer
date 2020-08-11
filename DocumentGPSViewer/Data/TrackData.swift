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
    var furthestPointFromStart: [CLLocation]
    var middlePoint: [CLLocation]
    var totalDistanceCalc: [CLLocationDistance]
    var totalDurationCalc: [DateInterval]
    var averageSpeed: [Speed]
    var maxSpeed: [Speed]
    var maxDistanceFromStart: [CLLocationDistance]
    var mapRegion: [MKCoordinateRegion]
    var trackPolyline: [MKPolyline]
    var speedColoredWaypoints: [[UIColor]]
    var polylineLocations: [[CGFloat]]
    var trackLocationPlacemark: [CLPlacemark?]
    var choosenLocationName: [String?]
    var maxTackDistance: [CLLocationDistance?]

    
    convenience init(fileName: String, fileExtension: String) {
        let data = openFile(fileName: fileName, fileExtension: fileExtension)
        self.init(data: data!)
    }
    
    init(data: Data) {
        self.waypoints = SBPDataToWaypoints(fileData: data)
        self.decodedWaypoints = decodeWaypoints(waypoints: self.waypoints)
        
        self.totalDistanceCalc = [CLLocationDistance]()
        self.furthestPointFromStart = [CLLocation]()
        self.middlePoint = [CLLocation]()
        self.totalDurationCalc = [DateInterval]()
        self.averageSpeed = [Speed]()
        self.maxSpeed = [Speed]()
        self.maxDistanceFromStart = [CLLocationDistance]()
        self.mapRegion = [MKCoordinateRegion]()
        self.trackPolyline = [MKPolyline]()
        self.speedColoredWaypoints = [[UIColor]]()
        self.polylineLocations = [[CGFloat]]()
        self.trackLocationPlacemark = [CLPlacemark]()
        self.choosenLocationName = [String?]()
        self.maxTackDistance = [CLLocationDistance]()
        
        
        for wps in self.decodedWaypoints {
            let distance = totalDistance(waypoints: wps)
            let duration = totalDuration(waypoints: wps)
            let avgSpeed = Speed(speedMS: (distance / duration.duration))
            let maxSpeed = Speed(speedMS: maxSpeedInstant(waypoints: wps))
            let (maxDistanceTack, furthestPoint) = furthestPointDistanceFromStart(waypoints: wps)
            let middlePoint = middlePointLocation(waypoint1: wps.first!, waypoint2: furthestPoint)
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
            
            self.trackLocationPlacemark.append(nil)
            self.choosenLocationName.append(nil)
            
            let geocoder = CLGeocoder()
            let locationIndex = trackLocationPlacemark.count-1
            geocoder.reverseGeocodeLocation(middlePoint, completionHandler: {(placemarks, error) in
                if error == nil {
                    self.savePlacemark(placemark: placemarks?.first, trackIndex: locationIndex)
                }
            })

            self.maxTackDistance.append(nil)
            self.totalDistanceCalc.append(distance)
            self.totalDurationCalc.append(duration)
            self.averageSpeed.append(avgSpeed)
            self.maxSpeed.append(maxSpeed)
            self.maxDistanceFromStart.append(maxDistanceTack)
            self.furthestPointFromStart.append(furthestPoint)
            self.middlePoint.append(middlePoint)
            self.mapRegion.append(mapRegion)
            self.trackPolyline.append(trackPolyline)
            self.speedColoredWaypoints.append(speedColoredWps)
            self.polylineLocations.append(polylineLocations)
            
        }
    }
    
    func savePlacemark(placemark: CLPlacemark?, trackIndex: Int) {
        self.trackLocationPlacemark[trackIndex] = placemark
        if placemark != nil {
            if placemark!.inlandWater != nil {
                self.choosenLocationName[trackIndex] = placemark!.inlandWater
            } else if placemark!.areasOfInterest?.first != nil {
                self.choosenLocationName[trackIndex] = placemark!.areasOfInterest!.first
            } else if placemark!.locality != nil {
                self.choosenLocationName[trackIndex] = placemark!.locality
            } else if placemark!.ocean != nil {
                self.choosenLocationName[trackIndex] = placemark!.ocean
            }
        }
    }
    
    func setMaxTackDistance(trackIndex: Int, distance: CLLocationDistance) {
        self.maxTackDistance[trackIndex] = distance
    }
    
    
}
