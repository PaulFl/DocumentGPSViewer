//
//  DistanceSegmentsSummaryView.swift
//  DocumentGPSViewer
//
//  Created by Paul Fleury on 13/08/2020.
//

import SwiftUI

struct DistanceSegmentsSummaryView: View {
    let segments: [TrackSegment]
    let distance: CLLocationDistance
    let amountToShow: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Top speeds over \(Int(distance))m")
                .fontWeight(.medium)
            VStack(alignment: .leading) {
                ForEach(0..<amountToShow) {i in
                    if i < segments.count {
                        SingleSegmentSummaryView(segment: segments[i])
                            .padding(.leading, 20)
                    }
                }
            }
        }
        .padding([.leading, .top], 10)
    }
}
