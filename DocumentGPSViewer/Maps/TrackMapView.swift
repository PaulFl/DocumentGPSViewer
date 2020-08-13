//
//  TrackMapView.swift
//  GPSViewer
//
//  Created by Paul Fleury on 26/07/2020.
//

import SwiftUI
import MapKit

struct TrackMapView: View {
    let trackData: SplitTrackData
    
    @State var mapRegion = MKCoordinateRegion()
    
    init(trackData: SplitTrackData) {
        self.trackData = trackData
       
        MKMapView.appearance().showsCompass = true
        MKMapView.appearance().showsScale = true
        
    }
    
    var body: some View {
        Map(coordinateRegion: $mapRegion, interactionModes: .all, showsUserLocation: true)
            .onAppear {
                mapRegion = trackData.mapRegion
            }
    }
}
