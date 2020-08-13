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
    let trackData: SplitTrackData
    @State var mapRegion = MKCoordinateRegion()
    let mapPin: MapPin
    
    init(trackData: SplitTrackData, trackIndex: Int) {
        self.trackData = trackData
        self.mapPin = MapPin(location: trackData.middlePoint.coordinate)
    }
    
    var body: some View {
        Map(coordinateRegion: $mapRegion, annotationItems: [mapPin], annotationContent: { (_) in
            return MapMarker(coordinate: trackData.middlePoint.coordinate)
                        })
            .frame(width: 85, height: 85, alignment: .center)
            .cornerRadius(12.0)
            .onAppear(perform: {
                mapRegion = miniMapRegion(waypoints: trackData.decodedWaypoints)
            })
    }
}
