//
//  MainStatsView.swift
//  DocumentGPSViewer
//
//  Created by Paul Fleury on 11/08/2020.
//

import SwiftUI

struct MainStatsView: View {
    let trackData: SplitTrackData
    let trackIndex: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "speedometer")
                    .foregroundColor(.red)
                    .frame(width: 10, height: 10, alignment: .center)
                let topSpeedLabel = String(format: "%.2f", trackData.maxSpeed.speedKPH) + " km/h (" + String(format: "%.2f", trackData.maxSpeed.speedKts) + " kts)"
                Text("Top speed: ")
                    .fontWeight(.medium)
                Text(topSpeedLabel)
            }
            HStack {
                Image(systemName: "point.topleft.down.curvedto.point.bottomright.up")
                    .frame(width: 10, height: 10, alignment: .center)
                let distanceLabel = String(format: "%.2f", trackData.totalDistanceCalc/1000) + " km"
                Text("Total distance: ")
                    .fontWeight(.medium)
                Text(distanceLabel)
            }
            HStack {
                Image(systemName: "point.topleft.down.curvedto.point.bottomright.up")
                    .frame(width: 10, height: 10, alignment: .center)
                let maxTackLabel = String(format: "%.2f", trackData.maxDistanceFromStart/1000) + " km"
                Text("Max dist from start: ")
                    .fontWeight(.medium)
                Text(maxTackLabel)
            }
            HStack {
                Image(systemName: "hourglass.bottomhalf.fill")
                    .frame(width: 10, height: 10, alignment: .center)
                let durationLabel = formatReadableDuration(duration: trackData.totalDurationCalc)
                Text("Total duration: ")
                    .fontWeight(.medium)
                Text(durationLabel)
            }
            HStack {
                Image(systemName: "sum")
                    .frame(width: 10, height: 10, alignment: .center)
                let avgSpeedLabel = String(format: "%.2f", trackData.averageSpeed.speedKPH) + " km/h (" + String(format: "%.2f", trackData.averageSpeed.speedKts) + " kts)"
                Text("Avg speed: ")
                    .fontWeight(.medium)
                Text(avgSpeedLabel)
            }
        }
    }
}
