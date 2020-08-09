//
//  ContentView.swift
//  DocumentGPSViewer
//
//  Created by Paul Fleury on 09/08/2020.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: DocumentGPSViewerDocument

    var body: some View {
        NavigationView {
            List() {
                ForEach(0..<document.trackData!.mapRegion.count) { i in
                    NavigationLink(
                        destination: TrackSummaryView(trackData: document.trackData!, trackIndex: i),
                        label: {
                            TrackIntervalRowView(trackData: document.trackData!, trackIndex: i)
                        })
                        .navigationTitle("Split tracks")
                }
            }
            .listStyle(SidebarListStyle())
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}

