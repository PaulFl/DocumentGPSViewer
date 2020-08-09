//
//  TrackProcessing.swift
//  GPSViewer
//
//  Created by Paul Fleury on 26/07/2020.
//

import Foundation
import MapKit

public func totalDuration(waypoints: [CLLocation]) -> DateInterval {
    return DateInterval(start: waypoints.first!.timestamp, end: waypoints.last!.timestamp)
}

public func formatReadableDuration(duration: DateInterval) -> String {
    let intervalFormatter = DateComponentsFormatter()
    intervalFormatter.allowedUnits = [.day, .hour, .minute, .second]
    intervalFormatter.unitsStyle = .abbreviated
    intervalFormatter.maximumUnitCount = 3
    return intervalFormatter.string(from: duration.duration) ?? "Couldn't calculate duration"
}

public func maxSpeedInstant(waypoints: [CLLocation]) -> CLLocationSpeed {
    var maxSpeed = waypoints[0].speed
    
    for wp in waypoints{
        if wp.speed > maxSpeed {
            maxSpeed = wp.speed
        }
    }
    
    return maxSpeed
}

public func totalDistance(waypoints: [CLLocation]) -> CLLocationDistance {
    if waypoints.count <= 1 {
        return Double(0)
    }
    
    var distance = CLLocationDistance(0)
    
    var startLocation = waypoints[0]
    var endLocation = waypoints[0]
    
    for i in 1..<waypoints.count {
        startLocation = endLocation
        endLocation = waypoints[i]
        
        let dist = endLocation.distance(from: startLocation)
        distance += dist
        
    }
    
    return distance
}

public func trackMapRegion(waypoints: [CLLocation]) -> MKCoordinateRegion {
    if waypoints.first == nil {
        return MKCoordinateRegion()
    }
    
    let spanFactor = 1.6
    
    var maxLat = waypoints.first!.coordinate.latitude
    var minLat = waypoints.first!.coordinate.latitude
    var maxLon = waypoints.first!.coordinate.longitude
    var minLon = waypoints.first!.coordinate.longitude
    for wp in waypoints {
        if wp.coordinate.latitude > maxLat {
            maxLat = wp.coordinate.latitude
        } else if wp.coordinate.latitude < minLat {
            minLat = wp.coordinate.latitude
        }
        
        if wp.coordinate.longitude > maxLon {
            maxLon = wp.coordinate.longitude
        } else if wp.coordinate.longitude < minLon {
            minLon = wp.coordinate.longitude
        }
    }
    
    let middleLat = (minLat + maxLat) / 2
    let middleLon = (minLon + maxLon) / 2
    
    let center = CLLocationCoordinate2D(latitude: middleLat, longitude: middleLon)
    let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat)*spanFactor, longitudeDelta: (maxLon - minLon)*spanFactor)
    
    return MKCoordinateRegion(center: center, span: span)
}

public func miniMapRegion(waypoints: [CLLocation]) -> MKCoordinateRegion {
    if waypoints.first == nil {
        return MKCoordinateRegion()
    }
    
    let spanFactor = 300.0
    
    var maxLat = waypoints.first!.coordinate.latitude
    var minLat = waypoints.first!.coordinate.latitude
    var maxLon = waypoints.first!.coordinate.longitude
    var minLon = waypoints.first!.coordinate.longitude
    for wp in waypoints {
        if wp.coordinate.latitude > maxLat {
            maxLat = wp.coordinate.latitude
        } else if wp.coordinate.latitude < minLat {
            minLat = wp.coordinate.latitude
        }
        
        if wp.coordinate.longitude > maxLon {
            maxLon = wp.coordinate.longitude
        } else if wp.coordinate.longitude < minLon {
            minLon = wp.coordinate.longitude
        }
    }
    
    let middleLat = (minLat + maxLat) / 2
    let middleLon = (minLon + maxLon) / 2
    
    let center = CLLocationCoordinate2D(latitude: middleLat, longitude: middleLon)
    let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat)*spanFactor, longitudeDelta: (maxLon - minLon)*spanFactor)
    
    return MKCoordinateRegion(center: center, span: span)
}
