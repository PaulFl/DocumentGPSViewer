//
//  TrackSummaryView.swift
//  GPSViewer
//
//  Created by Paul Fleury on 28/07/2020.
//

import SwiftUI
import MapKit

struct TrackSummaryView: View {
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalsizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    #endif
    let trackData: TrackData
    let trackIndex: Int
    var trackName: String
    
    init(trackData: TrackData, trackIndex: Int) {
        self.trackData = trackData
        self.trackIndex = trackIndex
        
        self.trackName = "T.\(trackIndex+1)"
        if trackData.choosenLocationName[trackIndex] != nil {
            self.trackName += " - \(trackData.choosenLocationName[trackIndex]!)"
        }
    }
    
    
    var body: some View {
        let map = TrackMKMapView(trackData: trackData, trackIndex: trackIndex)
        //        let map = TrackMapView(trackData: trackData)
        let stats = HStack {
            MainStatsView(trackData: trackData, trackIndex: trackIndex)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(Font.body.weight(.semibold))
        }
        #if os(iOS)
        if (horizontalsizeClass == .compact && verticalSizeClass == .regular) {
            VStack(alignment: .leading) {
                NavigationLink(destination: DetailedStatsView(trackData: trackData, trackIndex: trackIndex)){
                    stats
                }
                .buttonStyle(PlainButtonStyle())
                .padding()
                map
                    .frame(minWidth: 200, maxWidth: 400, minHeight: 350, maxHeight: 900)
            }
            .navigationBarTitle(self.trackName, displayMode: .inline)
        } else {
            HStack {
                VStack {
                    DetailedStatsView(trackData: trackData, trackIndex: trackIndex)
                    Spacer()
                }
                map
                    .frame(minWidth: 410, maxWidth: 900, minHeight: 500, maxHeight: 2000)
                    .ignoresSafeArea(edges: .trailing)
            }
            .navigationBarTitle(self.trackName, displayMode: .inline)
        }
        #else
        HStack {
            NavigationLink(destination: DetailedStatsView(trackData: trackData, trackIndex: trackIndex)){
                stats
            }
            .buttonStyle(PlainButtonStyle())
            .padding()
            map
                .frame(minWidth: 500, maxWidth: 900, minHeight: 500, maxHeight: 2000)
        }
        .navigationBarTitle(self.trackName, displayMode: .inline)
        #endif
    }
}

struct TrackSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        TrackSummaryView(trackData: TrackData(fileName: "20200726_Jullouville", fileExtension: "SBP"), trackIndex: 0)
    }
}
