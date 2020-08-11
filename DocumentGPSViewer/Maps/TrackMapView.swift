//
//  TrackMapView.swift
//  GPSViewer
//
//  Created by Paul Fleury on 26/07/2020.
//

import SwiftUI
import MapKit

struct TrackMapView: View {
    let trackData: TrackData
    
    @State var mapRegion = MKCoordinateRegion()
    
    init(trackData: TrackData) {
        self.trackData = trackData
       
        MKMapView.appearance().showsCompass = true
        MKMapView.appearance().showsScale = true
        
    }
    
    var body: some View {
        Map(coordinateRegion: $mapRegion, interactionModes: .all, showsUserLocation: true)
            .onAppear {
                mapRegion = trackData.mapRegion.last!
            }
    }
}

struct TrackMapView_Previews: PreviewProvider {
    static var previews: some View {
        TrackMapView(trackData: TrackData(fileName: "20200703_Monteynard", fileExtension: "SBP"))
    }
}
