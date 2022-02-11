//
//  DetailedStatsView.swift
//  DocumentGPSViewer
//
//  Created by Paul Fleury on 11/08/2020.
//

import SwiftUI
import MapKit

struct DetailedStatsView: View {
    let trackData: SplitTrackData
    let trackIndex: Int
    let start: String
    let end: String
    var trackName: String
    var tackComputing = true
    
    @State var computingSpeeds = false
    @State var computingTacks = false
    @State var progressTacks = 0.0
    @State var progressSpeeds = 0.0
    
    init(trackData: SplitTrackData, trackIndex: Int) {
        self.trackData = trackData
        self.trackIndex = trackIndex
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        self.start = dateFormatter.string(from: trackData.decodedWaypoints.first!.timestamp)
        self.end = dateFormatter.string(from: trackData.decodedWaypoints.last!.timestamp)
        
        self.trackName = "Track n°\(trackIndex+1)"
        if trackData.choosenLocationName != nil {
            self.trackName += " - \(trackData.choosenLocationName!)"
        }
    }
    
    var timeInfo: some View {
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
    }
    
    var tacksInfo: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "point.topleft.down.curvedto.point.bottomright.up")
                    .frame(width: 10, height: 10, alignment: .center)
                Text("Max tack dist: ")
                    .fontWeight(.medium)
                let maxTackDistance = trackData.maxTackDistance
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
                let maxTackDistance = trackData.maxTackDistance
                if maxTackDistance != nil {
                    Text(String(Int(trackData.totalDistanceCalc/maxTackDistance!)/1) + " tacks")
                } else {
                    Text(" - ")
                }
            }
        }
    }
    
    var tacksComputing: some View {
        VStack {
            ProgressView(value: progressTacks)
                .padding()
            HStack {
                Spacer()
                Button(action: {computeTacks()}, label: {
                    Text("Compute tacks")
                })
                .disabled(computingTacks)
                Spacer()
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(self.trackName)
                    .font(.title)
                    .padding()
                MainStatsView(trackData: trackData, trackIndex: trackIndex)
                    .padding()
                timeInfo
                    .padding([.leading, .trailing])
                SpeedsSummaryView(topSegments: trackData.topSegments)
                    .padding()
                Spacer()
                tacksInfo
                    .padding()
                tacksComputing
                    .padding()
                Spacer()
            }
        }
        .navigationBarTitle("Stats")
        
    }
    
    func computeTacks() {
        if !self.computingTacks {
            self.computingTacks = true
            DispatchQueue.global().async {
                var maxTackDistance = CLLocationDistance()
                for (index, wp1) in self.trackData.decodedWaypoints.enumerated() {
                    for wp2 in self.trackData.decodedWaypoints {
                        let dist = wp1.distance(from: wp2)
                        if dist > maxTackDistance {
                            maxTackDistance = dist
                        }
                    }
                    DispatchQueue.main.async {
                        self.progressTacks = Double(index) / Double(trackData.decodedWaypoints.count)
                    }
                }
                trackData.setMaxTackDistance(distance: maxTackDistance)
            }
        }
    }
}
