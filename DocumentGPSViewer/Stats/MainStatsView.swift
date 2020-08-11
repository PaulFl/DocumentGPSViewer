//
//  MainStatsView.swift
//  DocumentGPSViewer
//
//  Created by Paul Fleury on 11/08/2020.
//

import SwiftUI

struct MainStatsView: View {
    let trackData: TrackData
    let trackIndex: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "speedometer")
                    .foregroundColor(.red)
                    .frame(width: 10, height: 10, alignment: .center)
                let topSpeedLabel = String(format: "%.2f", trackData.maxSpeed[trackIndex].speedKPH) + " km/h (" + String(format: "%.2f", trackData.maxSpeed[trackIndex].speedKts) + " kts)"
                Text("Top speed: ")
                    .fontWeight(.medium)
                Text(topSpeedLabel)
            }
            HStack {
                Image(systemName: "point.topleft.down.curvedto.point.bottomright.up")
                    .frame(width: 10, height: 10, alignment: .center)
                let distanceLabel = String(format: "%.2f", trackData.totalDistanceCalc[trackIndex]/1000) + " km"
                Text("Total distance: ")
                    .fontWeight(.medium)
                Text(distanceLabel)
            }
            HStack {
                Image(systemName: "point.topleft.down.curvedto.point.bottomright.up")
                    .frame(width: 10, height: 10, alignment: .center)
                let maxTackLabel = String(format: "%.2f", trackData.maxTackDistance[trackIndex]/1000) + " km"
                Text("Max dist from start: ")
                    .fontWeight(.medium)
                Text(maxTackLabel)
            }
            HStack {
                Image(systemName: "hourglass.bottomhalf.fill")
                    .frame(width: 10, height: 10, alignment: .center)
                let durationLabel = formatReadableDuration(duration: trackData.totalDurationCalc[trackIndex])
                Text("Total duration: ")
                    .fontWeight(.medium)
                Text(durationLabel)
            }
            HStack {
                Image(systemName: "sum")
                    .frame(width: 10, height: 10, alignment: .center)
                let avgSpeedLabel = String(format: "%.2f", trackData.averageSpeed[trackIndex].speedKPH) + " km/h (" + String(format: "%.2f", trackData.averageSpeed[trackIndex].speedKts) + " kts)"
                Text("Avg speed: ")
                    .fontWeight(.medium)
                Text(avgSpeedLabel)
            }
        }
    }
}
