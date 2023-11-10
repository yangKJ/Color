//
//  ContentView.swift
//  PixelColor
//
//  Created by Condy on 2023/11/5.
//

import SwiftUI

struct ContentView: View {
    @State var selectedColor: Color = .red
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Pixel Color")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding(.leading, 20)
            Spacer()
                .frame(height: 20)
            
            ColorPicker("Select a Color", selection: $selectedColor)
                .frame(width: 150, height: 40)
                .padding(.leading, 20)
            
            ItemView(titles: ["Origin", "Inverted", "Gray"], pixels: [
                PixelColor.init(color: selectedColor),
                PixelColor.init(color: selectedColor).inverted,
                PixelColor.init(color: selectedColor).grayscaled(),
            ])
            
            ItemView(titles: ["Saturated", "Desaturated", "Complemented"], pixels: [
                PixelColor.init(color: selectedColor).saturated(),
                PixelColor.init(color: selectedColor).desaturated(),
                PixelColor.init(color: selectedColor).complemented(),
            ])
            
            ItemView(titles: ["Lighter", "Darkened", "AdjustHue"], pixels: [
                PixelColor.init(color: selectedColor).lighter(),
                PixelColor.init(color: selectedColor).darkened(),
                PixelColor.init(color: selectedColor).adjustedHue(amount: 45),
            ])
            
//            ItemView(titles: ["MixHSL", "MixRGB", "MixHSB"], pixels: [
//                PixelColor.init(color: selectedColor).mixed(in: .hsl, other: .one),
//                PixelColor.init(color: selectedColor).mixed(in: .rgb, other: .one),
//                PixelColor.init(color: selectedColor).mixed(in: .hsb, other: .one),
//            ])
//
            ItemView(titles: ["MixBlue", "MixGreen", "MixRed"], pixels: [
                PixelColor.init(color: selectedColor).mixed(other: .init(color: CrossPlatformColor.blue)),
                PixelColor.init(color: selectedColor).mixed(other: .init(color: CrossPlatformColor.green)),
                PixelColor.init(color: selectedColor).mixed(other: .init(color: CrossPlatformColor.red)),
            ])
            
            ItemView(titles: ["Tinted", "Shaded"], pixels: [
                PixelColor.init(color: selectedColor).tinted(),
                PixelColor.init(color: selectedColor).shaded(),
            ])
            
            Spacer()
        }
        .padding(50)
    }
}

struct ItemView: View {
    var titles: [String]
    var pixels: [PixelColor]
    
    var body: some View {
        #if os(macOS)
        let width = CGFloat(NSScreen.main!.frame.size.width - 1500) / 6
        #else
        let width = (UIScreen.main.bounds.size.width - 30) / 6
        #endif
        HStack {
            ForEach(Array(pixels.enumerated()), id: \.offset) { index, pixel in
                Spacer().frame(width: 15)
                VStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: width/2)
                        .fill(pixel.toColor())
                        .frame(width: width, height: width)
                    Text(titles[index])
                        .font(.headline)
                        .fontWeight(.medium)
                        .frame(width: width+30, height: 30)
                }
                .padding(.trailing, 20)
            }
        }
        Divider()
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
