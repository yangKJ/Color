//
//  HSB.swift
//  PixelColor
//
//  Created by Condy on 2023/11/7.
//

import Foundation

extension PixelColor {
    /// Hue, Saturation, and Brightness.
    public typealias HSBType = (hue: CGFloat, saturation: CGFloat, brightness: CGFloat)
    
    /// HSB (Hue, Saturation, and Brightness) represents color in a more human-understandable way,
    /// Which closely mimics how colors are perceived in real life.
    /// Defining color using HSB instead of RGB (Red, Green, and Blue) in App design,
    /// Can result in a more intuitive design with the creation of harmonious color schemes and color gradients.
    public enum HSB {
        case hue
        case saturation
        case brightness
    }
}

extension PixelColor.HSB {
    
    func adjusted(pixel: PixelColor, amount: CGFloat) -> PixelColor {
        let hsl = pixel.toHSBComponents()
        var hue = hsl[0]
        var saturation = hsl[1]
        var brightness = hsl[2]
        switch self {
        case .hue:
            hue += amount
        case .saturation:
            saturation += amount
        case .brightness:
            brightness += amount
        }
        return PixelColor.init(hue: hue, saturation: saturation, brightness: brightness, alpha: CGFloat(pixel.alpha))
    }
}

extension PixelColor.HSB {
    
    /// Convertring hue, saturation, brightness to red, green, blue value.
    /// - Parameters:
    ///   - hue: The hue component of the color object, specified as a value from 0.0 to 360.0 degree.
    ///   - saturation: The saturation component of the color object, specified as a value from 0.0 to 1.0.
    ///   - brightness: The brightness component of the color object, specified as a value from 0.0 to 1.0.
    public static func toRGB(hue: CGFloat, saturation: CGFloat, brightness: CGFloat) -> PixelColor.RGB {
        let h = hue.truncatingRemainder(dividingBy: 360.0) / 360.0
        let s = min(max(saturation, 0.0), 1.0)
        let b = min(max(brightness, 0.0), 1.0)
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
}

extension PixelColor {
    /// Returns the HSB (hue, saturation, brightness) components.
    /// Notes that hue values are between 0 to 360, saturation values are between 0 to 1 and brightness values are between 0 to 1.
    /// - Returns: return  hue, saturation, brightness.
    public var toHSB: HSBType {
        let hsb = toHSBComponents()
        return (hsb[0], hsb[1], hsb[2])
    }
    /// Returns the HSB (hue, saturation, brightness) components.
    /// Notes that hue values are between 0 to 360, saturation values are between 0 to 1 and brightness values are between 0 to 1.
    /// - Returns: return a array with [hue, saturation, brightness].
    public func toHSBComponents() -> [CGFloat] {
        let maximum = max(red, max(green, blue))
        let minimum = min(red, min(green, blue))
        var h: Float = 0.0
        let s: Float
        let v: Float = maximum
        if maximum == 0 {
            s = 0.0
        } else {
            s = (maximum - minimum) / maximum
        }
        if maximum == minimum {
            h = 0.0
        } else if maximum == red && green >= blue {
            h = 60 * (green - blue) / (maximum - minimum)
        } else if maximum == red && green < blue {
            h = 60 * (green - blue) / (maximum - minimum) + 360.0
        } else if maximum == blue {
            h = 60 * (red - green) / (maximum - minimum) + 240.0
        } else if maximum == green {
            h = 60 * (blue - red) / (maximum - minimum) + 120.0
        }
        return [CGFloat(h), CGFloat(s), CGFloat(v)]
    }
}
