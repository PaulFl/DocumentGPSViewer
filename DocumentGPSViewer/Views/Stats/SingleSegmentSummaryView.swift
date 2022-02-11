//
//  SingleSegmentSummaryView.swift
//  DocumentGPSViewer
//
//  Created by Paul Fleury on 13/08/2020.
//

import SwiftUI

struct SingleSegmentSummaryView: View {
    let segment: TrackSegment
    let date: String
    
    init(segment: TrackSegment) {
        self.segment = segment
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .medium
        
        self.date = dateFormatter.string(from: segment.date)
    }
    
    var body: some View {
        let speedLabel = "\(String(format: "%.2f", segment.averageSpeed.speedKPH)) km/h (\(String(format: "%.2f", segment.averageSpeed.speedKts)) kts)"
        let speedDescriptionLabel = self.date + " - \(String(format: "%.4f", segment.distance)) m in \(String(format: "%.2f", segment.duration.duration)) s"
        VStack(alignment: .leading) {
            Text(speedLabel)
            Text(speedDescriptionLabel)
                .fontWeight(.ultraLight)
                .padding(.leading, 20)
        }
    }
}
