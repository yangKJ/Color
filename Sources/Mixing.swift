//
//  Mixing.swift
//  PixelColor
//
//  Created by Condy on 2023/11/8.
//

import Foundation

extension PixelColor {
    
    /// Mixes the given color object with the receiver.
    /// Specifically, takes the average of each of the RGB components, optionally weighted by the given percentage.
    /// - Parameters:
    ///   - colorSpace: The color space used to mix the colors. By default it uses the RBG color space.
    ///   - weight: The weight specifies the amount of the given color object (between 0 and 1).
    ///   - pixelColor: A pixel color object to mix with the receiver.
    /// - Returns: A pixel color object corresponding to the two colors object mixed together.
    public func mixed(in colorSpace: ColorSpace = .rgb, weight: CGFloat = 0.5, other pixelColor: PixelColor) -> PixelColor {
        let weight = max(min(weight, 1.0), 0.0)
        switch colorSpace {
        case .rgb:
            let c1 = components
            let c2 = pixelColor.components
            let r = c1[0] + (weight * (c2[0] - c1[0]))
            let g = c1[1] + (weight * (c2[1] - c1[1]))
            let b = c1[2] + (weight * (c2[2] - c1[2]))
            let a = alpha + (Float(weight) * (pixelColor.alpha - alpha))
            return PixelColor.init(red: Float(r), green: Float(g), blue: Float(b), alpha: a)
        case .hsl:
            let c1 = toHSLComponents()
            let c2 = pixelColor.toHSLComponents()
            let h = c1[0] + (weight * mixedHue(source: c1[0], target: c2[0]))
            let s = c1[1] + (weight * (c2[1] - c1[1]))
            let l = c1[2] + (weight * (c2[2] - c1[2]))
            let a = CGFloat(alpha) + (weight * CGFloat(pixelColor.alpha - alpha))
            return PixelColor.init(hue: h, saturation: s, lightness: l, alpha: a)
        case .hsb:
            let c1 = toHSBComponents()
            let c2 = pixelColor.toHSBComponents()
            let h = c1[0] + (weight * mixedHue(source: c1[0], target: c2[0]))
            let s = c1[1] + (weight * (c2[1] - c1[1]))
            let b = c1[2] + (weight * (c2[2] - c1[2]))
            let a = CGFloat(alpha) + (weight * CGFloat(pixelColor.alpha - alpha))
            return PixelColor.init(hue: h, saturation: s, brightness: b, alpha: a)
        case .lab:
            let c1 = toLabComponents()
            let c2 = pixelColor.toLabComponents()
            let L = c1[0] + (weight * (c2[0] - c1[0]))
            let a = c1[1] + (weight * (c2[1] - c1[1]))
            let b = c1[2] + (weight * (c2[2] - c1[2]))
            let a_ = CGFloat(alpha) + (weight * CGFloat(pixelColor.alpha - alpha))
            return PixelColor.init(L: L, a: a, b: b, alpha: a_)
        }
    }
    
    /// Creates and returns a pixel color object corresponding to the mix of the receiver and an amount of black color, which increases lightness.
    /// - Parameter amount: Float between 0.0 and 1.0. The default amount is equal to 0.2.
    /// - Returns: A darker pixel color.
    public func shaded(amount: CGFloat = 0.2) -> PixelColor {
        let pixel = PixelColor(red: 0, green: 0, blue: 0, alpha: 1)
        return mixed(weight: amount, other: pixel)
    }
    
    /// Creates and returns a pixel color object corresponding to the mix of the receiver and an amount of white color, which reduces lightness.
    /// - Parameter amount: Float between 0.0 and 1.0. The default amount is equal to 0.2.
    /// - Returns: A lighter pixel color.
    public func tinted(amount: CGFloat = 0.2) -> PixelColor {
        let pixel = PixelColor(red: 1, green: 1, blue: 1, alpha: 1)
        return mixed(weight: amount, other: pixel)
    }
    
    private func mixedHue(source: CGFloat, target: CGFloat) -> CGFloat {
        if target > source && target - source > 180.0 {
            return target - source + 360.0
        } else if target < source && source - target > 180.0 {
            return target + 360.0 - source
        }
        return target - source
    }
}
