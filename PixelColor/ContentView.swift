//
//  ContentView.swift
//  PixelColor
//
//  Created by Condy on 2023/11/5.
//

import SwiftUI

// https://swdevnotes.com/swift/2023/convert-color-from-rgb-to-hsb-in-swift/

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
