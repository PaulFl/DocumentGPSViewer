//
//  TrackIntervalRowView.swift
//  DocumentGPSViewer
//
//  Created by Paul Fleury on 09/08/2020.
//

import SwiftUI

struct TrackIntervalRowView: View {
    let trackData: SplitTrackData
    let trackIndex: Int
    let start: String
    let end: String
    var trackName: String
    
    init(trackData: SplitTrackData, trackIndex: Int) {
        self.trackData = trackData
        self.trackIndex = trackIndex
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        self.start = dateFormatter.string(from: trackData.decodedWaypoints.first!.timestamp)
        self.end = dateFormatter.string(from: trackData.decodedWaypoints.last!.timestamp)
                
        self.trackName = "Track n°\(trackIndex+1)"
        if trackData.choosenLocationName != nil {
            self.trackName += " - \(trackData.choosenLocationName!)"
        }
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(self.trackName)
                    .font(.headline)
                Text("Start: \(start)")
                    .font(.subheadline)
                    .fontWeight(.light)
                Text("End: \(end)")
                    .font(.subheadline)
                    .fontWeight(.light)
            }
            Spacer()
            MiniMapView(trackData: trackData, trackIndex: trackIndex)
        }
    }
}
