//
//  TrackIntervalRowView.swift
//  DocumentGPSViewer
//
//  Created by Paul Fleury on 09/08/2020.
//

import SwiftUI

struct TrackIntervalRowView: View {
    let trackData: TrackData
    let trackIndex: Int
    let start: String
    let end: String
    var trackName: String
    
    init(trackData: TrackData, trackIndex: Int) {
        self.trackData = trackData
        self.trackIndex = trackIndex
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .medium
        
        self.start = dateFormatter.string(from: trackData.decodedWaypoints[trackIndex].first!.timestamp)
        self.end = dateFormatter.string(from: trackData.decodedWaypoints[trackIndex].last!.timestamp)
        
        self.trackName = "Track n°\(trackIndex+1)"
        if trackData.choosenLocationName[trackIndex] != nil {
            self.trackName += " - \(trackData.choosenLocationName[trackIndex]!)"
        }
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(self.trackName)
                Text("Start: \(start)")
                    .font(.subheadline)
                    .fontWeight(.ultraLight)
                Text("End: \(end)")
                    .font(.subheadline)
                    .fontWeight(.ultraLight)
            }
            Spacer()
            MiniMapView(trackData: trackData, trackIndex: trackIndex)
        }
    }
}

struct TrackIntervalRowView_Previews: PreviewProvider {
    static var previews: some View {
        TrackIntervalRowView(trackData: TrackData(fileName: "20200726_Jullouville", fileExtension: "SBP"), trackIndex: 0)
    }
}
