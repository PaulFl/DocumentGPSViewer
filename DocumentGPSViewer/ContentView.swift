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
        TextEditor(text: $document.text)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(DocumentGPSViewerDocument()))
    }
}
