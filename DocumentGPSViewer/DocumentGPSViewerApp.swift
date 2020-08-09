//
//  DocumentGPSViewerApp.swift
//  DocumentGPSViewer
//
//  Created by Paul Fleury on 09/08/2020.
//

import SwiftUI

@main
struct DocumentGPSViewerApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: DocumentGPSViewerDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
