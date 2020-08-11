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
    
    init(trackData: TrackData, trackIndex: Int) {
        self.trackData = trackData
        self.trackIndex = trackIndex
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        self.start = dateFormatter.string(from: trackData.decodedWaypoints[trackIndex].first!.timestamp)
        self.end = dateFormatter.string(from: trackData.decodedWaypoints[trackIndex].last!.timestamp)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            MainStatsView(trackData: trackData, trackIndex: trackIndex)
                .padding()
            Text("Start: \(start)")
            Text("End: \(end)")
            Spacer()
            
        }
        .navigationBarTitle("Stats")
    }
}
