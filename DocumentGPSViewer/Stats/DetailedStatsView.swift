//
//  DetailedStatsView.swift
//  DocumentGPSViewer
//
//  Created by Paul Fleury on 11/08/2020.
//

import SwiftUI

struct DetailedStatsView: View {
    let trackData: TrackData
    let trackIndex: Int
    let start: String
    let end: String
    var trackName: String
    
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
            Spacer()
            ProgressView(value: progress)
                .padding()
            HStack {
                Spacer()
                Button(action: {}, label: {
                    Text("Compute tacks")
                })
                Spacer()
            }
            Spacer()
        }
        .navigationBarTitle("Stats")
    }
}
