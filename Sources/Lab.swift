//
//  Lab.swift
//  PixelColor
//
//  Created by Condy on 2023/11/8.
//

import Foundation

extension PixelColor {
    /// CIE Lab Color Space
    public enum Lab {
        /// The lightness, specified as a value from 0 to 100.0.
        case lightness
        /// The red-green axis, specified as a value from -128.0 to 127.0.
        case a
        /// The yellow-blue axis, specified as a value from -128.0 to 127.0.
        case b
    }
}

extension PixelColor.Lab {
    /// Convertring L, a, b to red, green, blue value.
    /// - Parameters:
    ///   - L: The lightness, specified as a value from 0 to 100.0.
    ///   - a: The red-green axis, specified as a value from -128.0 to 127.0.
    ///   - b: The yellow-blue axis, specified as a value from -128.0 to 127.0.
    public static func toRGB(L: CGFloat, a: CGFloat, b: CGFloat) -> PixelColor.RGB {
        let clippedL = min(max(L, 0.0), 100.0)
        let clippedA = min(max(a, -128.0), 127.0)
        let clippedB = min(max(b, -128.0), 127.0)
        let normalized = { (c: CGFloat) -> CGFloat in
            pow(c, 3) > 0.008856 ? pow(c, 3) : (c - (16 / 116)) / 7.787
        }
        let preY = (clippedL + 16.0) / 116.0
        let preX = (clippedA / 500.0) + preY
        let preZ = preY - (clippedB / 200.0)
        let X = 95.05 * normalized(preX)
        let Y = 100.0 * normalized(preY)
        let Z = 108.9 * normalized(preZ)
        let (r, g, b) = PixelColor.XYZ.toRGB(X: X, Y: Y, Z: Z)
        return (r, g, b)
    }
}

extension PixelColor {
    /// Returns the Lab (lightness, red-green axis, yellow-blue axis) components.
    /// It is based on the CIE XYZ color space with an observer at 2° and a D65 illuminant.
    /// Notes that L values are between 0 to 100.0, a values are between -128 to 127.0 and b values are between -128 to 127.0.
    /// - Returns: return a array with [L, a, b].
    public func toLabComponents() -> [CGFloat] {
        let normalized = { (c: CGFloat) -> CGFloat in
            c > 0.008856 ? pow(c, 1.0 / 3.0) : (7.787 * c) + (16.0 / 116.0)
        }
        let xyz = toXYZComponents()
        let normalizedX = normalized(xyz[0] / 95.05)
        let normalizedY = normalized(xyz[1] / 100.0)
        let normalizedZ = normalized(xyz[2] / 108.9)
        let roundDecimal = { (_ x: CGFloat) -> CGFloat in
            CGFloat(Int(round(x * 1000.0))) / 1000.0
        }
        let L = roundDecimal((116.0 * normalizedY) - 16.0)
        let a = roundDecimal(500.0 * (normalizedX - normalizedY))
        let b = roundDecimal(200.0 * (normalizedY - normalizedZ))
        return [L, a, b]
    }
}
