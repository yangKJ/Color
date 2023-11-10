//
//  XYZ.swift
//  PixelColor
//
//  Created by Condy on 2023/11/8.
//

import Foundation

extension PixelColor {
    /// CIE XYZ Color Space.
    public enum XYZ {
        /// The mix of cone response curves, specified as a value from 0 to 95.05.
        case X
        /// The luminance, specified as a value from 0 to 100.0.
        case Y
        /// The quasi-equal to blue stimulation, specified as a value from 0 to 108.9.
        case Z
    }
}

extension PixelColor.XYZ {
    
    /// Convertring X, Y, Z to red, green, blue value.
    /// - Parameters:
    ///   - X: The mix of cone response curves, specified as a value from 0 to 95.05.
    ///   - Y: The luminance, specified as a value from 0 to 100.0.
    ///   - Z: The quasi-equal to blue stimulation, specified as a value from 0 to 108.9.
    public static func toRGB(X: CGFloat, Y: CGFloat, Z: CGFloat) -> PixelColor.RGB {
        let x = min(max(X, 0.0), 95.05) / 100.0
        let y = min(max(Y, 0.0), 100.0) / 100.0
        let z = min(max(Z, 0.0), 108.9) / 100.0
        let toRGB = { (c: CGFloat) -> CGFloat in
            let rgb = c > 0.0031308 ? 1.055 * pow(c, 1.0 / 2.4) - 0.055 : c * 12.92
            return abs(CGFloat(Int(round(rgb * 1000.0))) / 1000.0)
        }
        let r = toRGB((x * 3.24060) + (y * -1.5372) + (z * -0.4986))
        let g = toRGB((x * -0.9689) + (y * 1.87580) + (z * 0.04150))
        let b = toRGB((x * 0.05570) + (y * -0.2040) + (z * 1.05700))
        return (r, g, b)
    }
}

extension PixelColor {
    /// Returns the XYZ (mix of cone response curves, luminance, quasi-equal to blue stimulation) components.
    /// Notes that X values are between 0 to 95.05, Y values are between 0 to 100.0 and Z values are between 0 to 108.9.
    /// - Returns: return a array with [X, Y, Z].
    public func toXYZComponents() -> [CGFloat] {
        let toSRGB = { (c: CGFloat) -> CGFloat in
            c > 0.04045 ? pow((c + 0.055) / 1.055, 2.4) : c / 12.92
        }
        let r = toSRGB(CGFloat(red))
        let g = toSRGB(CGFloat(green))
        let b = toSRGB(CGFloat(blue))
        let roundDecimal = { (_ x: CGFloat) -> CGFloat in
            CGFloat(Int(round(x * 10000.0))) / 10000.0
        }
        let X = roundDecimal(((r * 0.4124) + (g * 0.3576) + (b * 0.1805)) * 100.0)
        let Y = roundDecimal(((r * 0.2126) + (g * 0.7152) + (b * 0.0722)) * 100.0)
        let Z = roundDecimal(((r * 0.0193) + (g * 0.1192) + (b * 0.9505)) * 100.0)
        return [X, Y, Z]
    }
}
