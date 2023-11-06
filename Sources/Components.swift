//
//  Components.swift
//  PixelColor
//
//  Created by Condy on 2023/11/5.
//

import Foundation

extension PixelColor {
    
    /// Return a array with [red, green, blue, alpha].
    public var components: [CGFloat] {
        [red, green, blue, alpha].map { CGFloat($0) }
    }
    
    /// Returns the RGBA (red, green, blue, alpha) components.
    /// - Returns: return a array with [red, green, blue, alpha].
    public func toRGBA() -> [Float] {
        [red, green, blue, alpha]
    }
    
    /// Returns the HSB (hue, saturation, brightness) components.
    /// - Returns: return a array with [hue, saturation, brightness].
    public func toHSBComponents() -> [CGFloat] {
        let maximum = max(red, max(green, blue))
        let minimum = min(red, min(green, blue))
        var h: Float = 0.0
        var s: Float = 0.0
        let v: Float = maximum
        if maximum == minimum {
            h = 0.0
        } else if maximum == red && green >= blue {
            h = 60 * (green - blue) / (maximum - minimum)
        } else if maximum == red && green < blue {
            h = 60 * (green - blue) / (maximum - minimum) + 360
        } else if maximum == green {
            h = 60 * (blue - red) / (maximum - minimum) + 120
        } else if maximum == blue {
            h = 60 * (red - green) / (maximum - minimum) + 240
        }
        if maximum == 0 {
            s = 0
        } else {
            s = (maximum - minimum) / maximum
        }
        return [CGFloat(h), CGFloat(s), CGFloat(v)]
    }
    
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
        var s: Float = 0.0
        let l: Float = (maximum + minimum) / 2.0
        if l < 0.5 {
            s = delta / (maximum + minimum)
        } else {
            s = delta / (2.0 - maximum - minimum)
        }
        if red == maximum {
            h = ((green - blue) / delta) + (green < blue ? 6.0 : 0.0)
        } else if green == maximum {
            h = ((blue - red) / delta) + 2.0
        } else if blue == maximum {
            h = ((red - green) / delta) + 4.0
        }
        h /= 6.0
        return [CGFloat(h * 360.0), CGFloat(s), CGFloat(l)]
    }
}
