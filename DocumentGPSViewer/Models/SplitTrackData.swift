//
//  SplitTrackData.swift
//  DocumentGPSViewer
//
//  Created by Paul Fleury on 12/08/2020.
//

import Foundation
import MapKit

struct TrackSegment {
    let startWpIndex: Int
    let endWpIndex: Int
    let distance: CLLocationDistance
    let averageSpeed: Speed
    var duration: DateInterval
    let date: Date
}

class SplitTrackData {
    let decodedWaypoints: [CLLocation]
    var furthestPointFromStart: CLLocation
    var middlePoint: CLLocation
    var totalDistanceCalc: CLLocationDistance
    var totalDurationCalc: DateInterval
    var averageSpeed: Speed
    var maxSpeed: Speed
    var maxDistanceFromStart: CLLocationDistance
    var mapRegion: MKCoordinateRegion
    var trackPolyline: MKPolyline
    var speedColoredWaypoints: [UIColor]
    var polylineLocations: [CGFloat]
    var trackLocationPlacemark: CLPlacemark?
    var choosenLocationName: String?
    var maxTackDistance: CLLocationDistance?
    var pointToPointDistance: [CLLocationDistance]
    var topSegments: (meters50: [TrackSegment]?, meters100: [TrackSegment]?, meters200: [TrackSegment]?, meters500: [TrackSegment]?)
    
    init(decodedWaypoints: [CLLocation]) {
        self.decodedWaypoints = decodedWaypoints
        
        self.totalDistanceCalc = totalDistance(waypoints: decodedWaypoints)
        self.totalDurationCalc = totalDuration(waypoints: decodedWaypoints)
        self.averageSpeed = Speed(speedMS: (self.totalDistanceCalc / self.totalDurationCalc.duration))
        self.maxSpeed = Speed(speedMS: maxSpeedInstant(waypoints: decodedWaypoints))
        let (maxDistanceTack, furthestPoint) = furthestPointDistanceFromStart(waypoints: decodedWaypoints)
        self.maxDistanceFromStart = maxDistanceTack
        self.furthestPointFromStart = furthestPoint
        self.maxTackDistance = nil
        self.middlePoint = middlePointLocation(waypoint1: decodedWaypoints.first!, waypoint2: furthestPoint)
        self.mapRegion = trackMapRegion(waypoints: decodedWaypoints)
        // self.trackPolyline = MKPolyline(coordinates: decodedWaypoints.map({$0.coordinate}), count: decodedWaypoints.count)
        self.trackPolyline = GradientPolyline(locations: decodedWaypoints, maxSpeed: self.maxSpeed.speedMS)
        self.pointToPointDistance = []
        self.topSegments = (meters50: nil, meters100: nil, meters200: nil, meters500: nil)
        
        
        var speedColoredWps = [UIColor]()
        var polylineLocations = [CGFloat]()
        
        for i in 0..<decodedWaypoints.count {
            let wp = decodedWaypoints[i]
            let color = UIColor(red: CGFloat(wp.speed / maxSpeed.speedMS), green: CGFloat(1 - wp.speed / maxSpeed.speedMS), blue: 0.0, alpha: 1.0)
            speedColoredWps.append(color)
            polylineLocations.append(self.trackPolyline.location(atPointIndex: i))

            if i != 0 {
                self.pointToPointDistance.append(wp.distance(from: decodedWaypoints[i-1]))
            }
        }
        
        self.speedColoredWaypoints = speedColoredWps
        self.polylineLocations = polylineLocations
        
        self.trackLocationPlacemark = nil
        self.choosenLocationName = nil
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(middlePoint, completionHandler: {(placemarks, error) in
            if error == nil {
                self.savePlacemark(placemark: placemarks?.first)
            }
        })
        
        self.computeTopSegments()
    }
    
    func savePlacemark(placemark: CLPlacemark?) {
        self.trackLocationPlacemark = placemark
        if placemark != nil {
            if placemark!.inlandWater != nil {
                self.choosenLocationName = placemark!.inlandWater
            } else if placemark!.areasOfInterest?.first != nil {
                self.choosenLocationName = placemark!.areasOfInterest!.first
            } else if placemark!.locality != nil {
                self.choosenLocationName = placemark!.locality
            } else if placemark!.ocean != nil {
                self.choosenLocationName = placemark!.ocean
            }
        }
    }
    
    func setMaxTackDistance(distance: CLLocationDistance) {
        self.maxTackDistance = distance
    }
    
    func getSortedSegmentsForDistance(distance: CLLocationDistance) -> [TrackSegment] {
        var segments = [TrackSegment]()
        var currentDistance = CLLocationDistance()
        var currentStartIndex = 0
        for (index, dist) in self.pointToPointDistance.enumerated() {
            currentDistance += dist
            if currentDistance >= distance {
                let startDate = self.decodedWaypoints[currentStartIndex].timestamp
                let duration = DateInterval(start: startDate, end: self.decodedWaypoints[index+1].timestamp)
                let averageSpeed = Speed(speedMS: (currentDistance / duration.duration))
                segments.append(TrackSegment(startWpIndex: currentStartIndex, endWpIndex: index+1, distance: currentDistance, averageSpeed: averageSpeed, duration: duration, date: startDate))
            }
            while currentDistance >= distance {
                currentDistance -= self.pointToPointDistance[currentStartIndex]
                currentStartIndex += 1
            }
        }
        segments.sort {
            $0.averageSpeed.speedMS > $1.averageSpeed.speedMS
        }
        return segments
    }
    
    func getTopSegmentsForDistance(distance: CLLocationDistance) -> [TrackSegment] {
        let segments = self.getSortedSegmentsForDistance(distance: distance)
        var topSegments = [TrackSegment]()
        
        for seg in segments {
            var alreadyContained = false
            for topSeg in topSegments {
                if ((seg.startWpIndex > topSeg.startWpIndex) && (seg.startWpIndex < topSeg.endWpIndex)) || ((seg.endWpIndex > topSeg.startWpIndex) && (seg.endWpIndex < topSeg.endWpIndex)) {
                    alreadyContained = true
                    break
                }
            }
            if !alreadyContained {
                topSegments.append(seg)
            }
        }
        return topSegments
    }
    
    func computeTopSegments() {
        self.topSegments.meters50 = getTopSegmentsForDistance(distance: CLLocationDistance(50))
        self.topSegments.meters100 = getTopSegmentsForDistance(distance: CLLocationDistance(100))
        self.topSegments.meters200 = getTopSegmentsForDistance(distance: CLLocationDistance(200))
        self.topSegments.meters500 = getTopSegmentsForDistance(distance: CLLocationDistance(500))
    }
    
}
