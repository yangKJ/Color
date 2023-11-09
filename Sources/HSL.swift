//
//  HSL.swift
//  PixelColor
//
//  Created by Condy on 2023/11/7.
//

import Foundation

extension PixelColor {
    /// Hue, Saturation, and Lightness.
    public typealias HSLType = (hue: CGFloat, saturation: CGFloat, lightness: CGFloat)
    
    public enum HSL {
        case hue
        case saturation
        case lightness
    }
}

extension PixelColor.HSL {
    
    func adjusted(pixel: PixelColor, amount: CGFloat) -> PixelColor {
        let hsl = pixel.toHSLComponents()
        var hue = hsl[0]
        var saturation = hsl[1]
        var lightness = hsl[2]
        switch self {
        case .hue:
            hue += amount
        case .saturation:
            saturation += amount
        case .lightness:
            lightness += amount
        }
        return PixelColor.init(hue: hue, saturation: saturation, lightness: lightness, alpha: CGFloat(pixel.alpha))
    }
}

extension PixelColor.HSL {
    
    /// Convertring hue, saturation, lightness to red, green, blue value.
    /// - Parameters:
    ///   - hue: The hue component of the color object, specified as a value from 0.0 to 360.0 degree.
    ///   - saturation: The saturation component of the color object, specified as a value from 0.0 to 1.0.
    ///   - lightness: The lightness component of the color object, specified as a value between 0.0 and 1.0.
    public static func toRGB(hue: CGFloat, saturation: CGFloat, lightness: CGFloat) -> PixelColor.RGB {
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
    
    /// Convertring hue, saturation, lightness to hue, saturation, brightness value.
    /// - Parameters:
    ///   - hue: The hue component of the color object, specified as a value from 0.0 to 360.0 degree.
    ///   - saturation: The saturation component of the color object, specified as a value from 0.0 to 1.0.
    ///   - lightness: The lightness component of the color object, specified as a value between 0.0 and 1.0.
    /// - Returns: return Hue, Saturation, and Brightness.
    public static func toHSB(hue: CGFloat, saturation: CGFloat, lightness: CGFloat) -> PixelColor.HSBType {
        let brightness = lightness + saturation * min(lightness, 1.0 - lightness)
        let newSaturation: CGFloat
        if brightness == 0 {
            newSaturation = 0.0
        } else {
            newSaturation = 2.0 * (1.0 - lightness / brightness)
        }
        return (hue: hue, saturation: newSaturation, brightness: brightness)
    }
}

extension PixelColor {
    /// Returns the HSL (hue, saturation, lightness) components.
    /// - Returns: return a array with [hue, saturation, lightness].
    public func toHSLComponents() -> [CGFloat] {
        let maximum = max(red, max(green, blue))
        let minimum = min(red, min(green, blue))
        let delta = maximum - minimum
        guard delta != 0.0 else {
            return [0.0, 0.0, CGFloat(maximum)]
        }
        var h: Float = 0.0
        let s: Float
        let l: Float = (maximum + minimum) / 2.0
        if l < 0.5 {
            s = delta / (maximum + minimum)
        } else {
            s = delta / (2.0 - maximum - minimum)
        }
        switch maximum {
        case red:
            h = ((green - blue) / delta) + (green < blue ? 6.0 : 0.0)
        case green:
            h = ((blue - red) / delta) + 2.0
        case blue:
            h = ((red - green) / delta) + 4.0
        default:
            break
        }
        //h /= 6.0
        return [CGFloat(h) * 60.0, CGFloat(s), CGFloat(l)]
    }
}
