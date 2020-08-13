//
//  SpeedsSummaryView.swift
//  DocumentGPSViewer
//
//  Created by Paul Fleury on 13/08/2020.
//

import SwiftUI
import MapKit

struct SpeedsSummaryView: View {
    let topSegments: (meters50: [TrackSegment]?, meters100: [TrackSegment]?, meters200: [TrackSegment]?, meters500: [TrackSegment]?)
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Top avg speeds")
                .fontWeight(.semibold)
            if topSegments.meters50 != nil {
                DistanceSegmentsSummaryView(segments: topSegments.meters50!, distance: CLLocationDistance(50), amountToShow: 3)
            }
            if topSegments.meters100 != nil {
                DistanceSegmentsSummaryView(segments: topSegments.meters100!, distance: CLLocationDistance(100), amountToShow: 3)
            }
            if topSegments.meters200 != nil {
                DistanceSegmentsSummaryView(segments: topSegments.meters200!, distance: CLLocationDistance(200), amountToShow: 3)
            }
            if topSegments.meters500 != nil {
                DistanceSegmentsSummaryView(segments: topSegments.meters500!, distance: CLLocationDistance(500), amountToShow: 3)
            }
        }
    }
}
