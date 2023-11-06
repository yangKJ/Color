//
//  Converting.swift
//  PixelColor
//
//  Created by Condy on 2023/11/5.
//

import Foundation

extension PixelColor {
    struct Converting { }
}

extension PixelColor.Converting {
    
    /// red, green, blue
    typealias RGB = (red: CGFloat, green: CGFloat, blue: CGFloat)
    typealias RGBA = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    
    /// HSB to RGB.
    /// - Parameters:
    ///   - hue: The hue component of the color object, specified as a value from 0.0 to 360.0 degree.
    ///   - saturation: The saturation component of the color object, specified as a value from 0.0 to 1.0.
    ///   - brightness: The brightness component of the color object, specified as a value from 0.0 to 1.0.
    static func HSB2RGB(hue: CGFloat, saturation: CGFloat, brightness: CGFloat) -> RGB {
        let h = hue.truncatingRemainder(dividingBy: 360.0) / 360.0
        let s = min(max(saturation, 0.0), 1.0)
        let b = min(max(brightness, 0.0), 1.0)
        //let color = CrossPlatformColor(hue: h, saturation: s, brightness: b, alpha: alpha)
        //self.init(color: color)
        var red: CGFloat = 0.0, blue: CGFloat = 0.0, green: CGFloat = 0.0
        let i = (h * 6).rounded(.down)
        let f = h * 6 - i
        let p = b * (1 - s)
        let q = b * (1 - f * s)
        let t = b * (1 - (1 - f) * s)
        switch h * 360 {
        case 0..<60, 360:
            red = b; green = t; blue = p
        case 60..<120:
            red = q; green = b; blue = p
        case 120..<180:
            red = p; green = b; blue = t
        case 180..<240:
            red = p; green = q; blue = b
        case 240..<300:
            red = t; green = p; blue = b
        case 300..<360:
            red = b; green = p; blue = q
        default:
            break
        }
        return (red, green, blue)
    }
    
    /// HSL to RGB.
    /// - Parameters:
    ///   - hue: The hue component of the color object, specified as a value from 0.0 to 360.0 degree.
    ///   - saturation: The saturation component of the color object, specified as a value from 0.0 to 1.0.
    ///   - lightness: The lightness component of the color object, specified as a value between 0.0 and 1.0.
    static func HSL2RGB(hue: CGFloat, saturation: CGFloat, lightness: CGFloat) -> RGB {
        let h = hue.truncatingRemainder(dividingBy: 360.0) / 360.0
        let s = min(max(saturation, 0.0), 1.0)
        let l = min(max(lightness, 0.0), 1.0)
        /// Hue to RGB helper function
        let hueToRGB = { (m1: CGFloat, m2: CGFloat, h: CGFloat) -> CGFloat in
            let hue = (h.truncatingRemainder(dividingBy: 1) + 1).truncatingRemainder(dividingBy: 1)
            if hue * 6 < 1.0 {
                return m1 + ((m2 - m1) * hue * 6.0)
            } else if hue * 2.0 < 1.0 {
                return m2
            } else if hue * 3.0 < 1.9999 {
                return m1 + ((m2 - m1) * ((2.0 / 3.0) - hue) * 6.0)
            }
            return m1
        }
        let m2 = l <= 0.5 ? l * (s + 1.0) : (l + s) - (l * s)
        let m1 = (l * 2.0) - m2
        let r = hueToRGB(m1, m2, h + (1.0 / 3.0))
        let g = hueToRGB(m1, m2, h)
        let b = hueToRGB(m1, m2, h - (1.0 / 3.0))
        return (r, g, b)
    }
    
    /// Hex string to RGBA, e.g. "#D6A5A4".
    /// Support hex string `#RGB`,`RGB`,`#ARGB`,`ARGB`,`#RRGGBB`,`RRGGBB`,`#AARRGGBB`,`AARRGGBB`.
    /// - Parameter hex: A hexa-decimal color string representation.
    static func hexString2RGBA(hex: String) -> RGBA {
        let input = hex.replacingOccurrences(of: "#", with: "").uppercased()
        var a: CGFloat = 1.0, r: CGFloat = 0.0, b: CGFloat = 0.0, g: CGFloat = 0.0
        func colorComponent(from string: String, start: Int, length: Int) -> CGFloat {
            let substring = (string as NSString).substring(with: NSRange(location: start, length: length))
            let fullHex = length == 2 ? substring : "\(substring)\(substring)"
            var hexComponent: UInt64 = 0
            Scanner(string: fullHex).scanHexInt64(&hexComponent)
            return CGFloat(Double(hexComponent) / 255.0)
        }
        switch (input.count) {
        case 3 /* #RGB */:
            r = colorComponent(from: input, start: 0, length: 1)
            g = colorComponent(from: input, start: 1, length: 1)
            b = colorComponent(from: input, start: 2, length: 1)
        case 4 /* #ARGB */:
            a = colorComponent(from: input, start: 0, length: 1)
            r = colorComponent(from: input, start: 1, length: 1)
            g = colorComponent(from: input, start: 2, length: 1)
            b = colorComponent(from: input, start: 3, length: 1)
        case 6 /* #RRGGBB */:
            r = colorComponent(from: input, start: 0, length: 2)
            g = colorComponent(from: input, start: 2, length: 2)
            b = colorComponent(from: input, start: 4, length: 2)
        case 8 /* #AARRGGBB */:
            a = colorComponent(from: input, start: 0, length: 2)
            r = colorComponent(from: input, start: 2, length: 2)
            g = colorComponent(from: input, start: 4, length: 2)
            b = colorComponent(from: input, start: 6, length: 2)
        default:
            break
        }
        return (r, g, b, a)
    }
}
