//
//  DetailedStatsView.swift
//  DocumentGPSViewer
//
//  Created by Paul Fleury on 11/08/2020.
//

import SwiftUI
import MapKit

struct DetailedStatsView: View {
    let trackData: TrackData
    let trackIndex: Int
    let start: String
    let end: String
    var trackName: String
    var tackComputing = true
    
    @State var computingTacks = false
    @State var progress = 0.0
    
    init(trackData: TrackData, trackIndex: Int) {
        self.trackData = trackData
        self.trackIndex = trackIndex
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        self.start = dateFormatter.string(from: trackData.decodedWaypoints[trackIndex].first!.timestamp)
        self.end = dateFormatter.string(from: trackData.decodedWaypoints[trackIndex].last!.timestamp)
        
        self.trackName = "Track n°\(trackIndex+1)"
        if trackData.choosenLocationName[trackIndex] != nil {
            self.trackName += " - \(trackData.choosenLocationName[trackIndex]!)"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(self.trackName)
                .font(.title)
                .padding()
            MainStatsView(trackData: trackData, trackIndex: trackIndex)
                .padding()
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "play")
                        .frame(width: 10, height: 10, alignment: .center)
                    Text("Start: ")
                        .fontWeight(.medium)
                    Text(start)
                }
                HStack {
                    Image(systemName: "stop")
                        .frame(width: 10, height: 10, alignment: .center)
                    Text("End: ")
                        .fontWeight(.medium)
                    Text(end)
                }
            }
            .padding()
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "point.topleft.down.curvedto.point.bottomright.up")
                        .frame(width: 10, height: 10, alignment: .center)
                    Text("Max tack dist: ")
                        .fontWeight(.medium)
                    let maxTackDistance = trackData.maxTackDistance[trackIndex]
                    if maxTackDistance != nil {
                        Text(String(format: "%.2f", maxTackDistance!/1000) + " km")
                    } else {
                        Text(" - ")
                    }
                }
                HStack {
                    Image(systemName: "point.topleft.down.curvedto.point.bottomright.up")
                        .frame(width: 10, height: 10, alignment: .center)
                    Text("Min tack amount: ")
                        .fontWeight(.medium)
                    let maxTackDistance = trackData.maxTackDistance[trackIndex]
                    if maxTackDistance != nil {
                        Text(String(Int(trackData.totalDistanceCalc[trackIndex]/maxTackDistance!)/1) + " tacks")
                    } else {
                        Text(" - ")
                    }
                }
            }
            .padding()
            Spacer()
            ProgressView(value: progress)
                .padding()
            HStack {
                Spacer()
                Button(action: {computeTacks()}, label: {
                    Text("Compute tacks")
                })
                .disabled(computingTacks)
                Spacer()
            }
            Spacer()
        }
        .navigationBarTitle("Stats")
    }
    
    func computeTacks() {
        if !self.computingTacks {
            self.computingTacks = true
            DispatchQueue.global().async {
                var maxTackDistance = CLLocationDistance()
                for (index, wp1) in self.trackData.decodedWaypoints[trackIndex].enumerated() {
                    for wp2 in self.trackData.decodedWaypoints[trackIndex] {
                        let dist = wp1.distance(from: wp2)
                        if dist > maxTackDistance {
                            maxTackDistance = dist
                        }
                    }
                    DispatchQueue.main.async {
                        self.progress = Double(index) / Double(trackData.decodedWaypoints[trackIndex].count)
                    }
                }
                trackData.setMaxTackDistance(trackIndex: trackIndex, distance: maxTackDistance)
            }
        }
    }
}
