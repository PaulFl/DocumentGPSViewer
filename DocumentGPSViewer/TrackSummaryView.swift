//
//  TrackSummaryView.swift
//  GPSViewer
//
//  Created by Paul Fleury on 28/07/2020.
//

import SwiftUI
import MapKit

struct TrackSummaryView: View {
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalsizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    #endif
    let trackData: TrackData
    let trackIndex: Int
    
    
    var body: some View {
        let map = TrackMKMapView(trackData: trackData, trackIndex: trackIndex)
        //        let map = TrackMapView(trackData: trackData)
        let stats = VStack(alignment: .leading) {
            HStack {
                Image(systemName: "speedometer")
                    .foregroundColor(.red)
                let topSpeedLabel = String(format: "%.2f", trackData.maxSpeed[trackIndex].speedKPH) + " km/h (" + String(format: "%.2f", trackData.maxSpeed[trackIndex].speedKts) + " kts)"
                Text("Top speed: ")
                    .fontWeight(.medium)
                Text(topSpeedLabel)
            }
            HStack {
                Image(systemName: "point.topleft.down.curvedto.point.bottomright.up")
                let distanceLabel = String(format: "%.2f", trackData.totalDistanceCalc[trackIndex]/1000) + " km"
                Text("Total distance: ")
                    .fontWeight(.medium)
                Text(distanceLabel)
            }
            HStack {
                Image(systemName: "hourglass.bottomhalf.fill")
                let durationLabel = formatReadableDuration(duration: trackData.totalDurationCalc[trackIndex])
                Text("Total duration: ")
                    .fontWeight(.medium)
                Text(durationLabel)
            }
            HStack {
                Image(systemName: "sum")
                let avgSpeedLabel = String(format: "%.2f", trackData.averageSpeed[trackIndex].speedKPH) + " km/h (" + String(format: "%.2f", trackData.averageSpeed[trackIndex].speedKts) + " kts)"
                Text("Avg speed: ")
                    .fontWeight(.medium)
                Text(avgSpeedLabel)
            }
        }
        #if os(iOS)
        if (horizontalsizeClass == .compact && verticalSizeClass == .regular) {
            VStack(alignment: .leading) {
                stats
                    .padding()
                map
                    .frame(minWidth: 200, maxWidth: 400, minHeight: 350, maxHeight: 900)
            }
            .navigationBarTitle("Track n°\(trackIndex+1)", displayMode: .inline)
        } else {
            HStack {
                VStack {
                    stats
                        .padding()
                    Spacer()
                }
                map
                    .frame(minWidth: 410, maxWidth: 900, minHeight: 500, maxHeight: 2000)
            }
        }
        #else
        HStack {
            stats
                .padding()
            map
                .frame(minWidth: 500, maxWidth: 900, minHeight: 500, maxHeight: 2000)
        }
        #endif
    }
}

struct TrackSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        TrackSummaryView(trackData: TrackData(fileName: "20200726_Jullouville", fileExtension: "SBP"), trackIndex: 0)
    }
}
