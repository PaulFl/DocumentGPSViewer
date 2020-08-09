//
//  DocumentGPSViewerDocument.swift
//  DocumentGPSViewer
//
//  Created by Paul Fleury on 09/08/2020.
//

import SwiftUI
import UniformTypeIdentifiers


extension UTType {
    static var exampleText: UTType {
        UTType(importedAs: "com.paulfly.SBP")
    }
}

struct DocumentGPSViewerDocument: FileDocument {
    let trackData: TrackData?
    static var readableContentTypes: [UTType] { [.data] }
    
    init() {
        self.trackData = nil
    }

    init(fileWrapper: FileWrapper, contentType: UTType) throws {
        let data = fileWrapper.regularFileContents
        self.trackData = TrackData(data: data!)
    }
    
    func write(to fileWrapper: inout FileWrapper, contentType: UTType) throws {
    }
}
