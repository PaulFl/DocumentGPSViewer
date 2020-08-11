//
//  MiniMapView.swift
//  DocumentGPSViewer
//
//  Created by Paul Fleury on 09/08/2020.
//

import SwiftUI
import MapKit

struct MapPin: Identifiable {
    let id = UUID()
    let location: CLLocationCoordinate2D
}

struct MiniMapView: View {
    let trackData: TrackData
    let trackIndex: Int
    @State var mapRegion = MKCoordinateRegion()
    let mapPin: MapPin
    
    init(trackData: TrackData, trackIndex: Int) {
        self.trackIndex = trackIndex
        self.trackData = trackData
        self.mapPin = MapPin(location: trackData.decodedWaypoints[trackIndex].first!.coordinate)
    }
    
    var body: some View {
        Map(coordinateRegion: $mapRegion, annotationItems: [mapPin], annotationContent: { (_) in
            return MapMarker(coordinate: trackData.middlePoint[trackIndex].coordinate)
                        })
            .frame(width: 100, height: 100, alignment: .center)
            .cornerRadius(16.0)
            .onAppear(perform: {
                mapRegion = miniMapRegion(waypoints: trackData.decodedWaypoints[trackIndex])
            })
    }
}
