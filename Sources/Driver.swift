//
//  Driver.swift
//  PixelColor
//
//  Created by Condy on 2023/11/5.
//

import Foundation
import SwiftUI

extension PixelColor {
    
    /// A boolean value to know whether the color is light. If false the color is light, dark otherwise.
    /// Determines if the color object is dark or light.
    /// It is useful when you need to know whether you should display the text in black or white.
    public var isDark: Bool {
        let brightness = ((red * 299.0) + (green * 587.0) + (blue * 114.0)) / 1000.0
        return brightness > 0.5
    }
    
    /// A float value representing the luminance of the current color. May vary from 0 to 1.0.
    /// You can read more here: https://www.w3.org/TR/WCAG20/#relativeluminancedef.
    public var luminance: CGFloat {
        let rgb = [red, green, blue].map {
            guard $0 <= 0.03928 else {
                return CGFloat(powf(($0 + 0.055) / 1.055, 2.4))
            }
            return CGFloat($0 / 12.92)
        }
        return (0.2126 * rgb[0]) + (0.7152 * rgb[1]) + (0.0722 * rgb[2])
    }
    
    /// Returns a float value representing the contrast ratio between 2 pixel colors.
    /// https://www.w3.org/TR/WCAG20-TECHS/G18.html
    /// - Parameter pixelColor: The other pixel color to compare with.
    /// - Returns: A CGFloat representing contrast value.
    public func contrastRatio(with pixelColor: PixelColor) -> CGFloat {
        let otherLuminance = pixelColor.luminance
        let l1 = max(luminance, otherLuminance)
        let l2 = min(luminance, otherLuminance)
        return (l1 + 0.05) / (l2 + 0.05)
    }
    
    /// Indicates if two colors are contrasting, regarding W3C's WCAG 2.0 recommendations.
    /// https://www.w3.org/TR/2008/REC-WCAG20-20081211/#visual-audio-contrast-contrast
    /// The acceptable contrast ratio depends on the context of display. Most of the time, the default context (.Standard) is enough.
    /// - Parameters:
    ///   - pixelColor: The other pixel color to compare with.
    ///   - context: An optional context to determine the minimum acceptable contrast ratio. Default value is .Standard.
    /// - Returns: true is the contrast ratio between 2 pixel colors exceed the minimum acceptable ratio.
    public func isContrasting(with pixelColor: PixelColor, inContext context: ContrastDisplayContext = .standard) -> Bool {
        contrastRatio(with: pixelColor) > context.minimumContrastRatio
    }
}

extension PixelColor {
    
    /// The red, green, and blue values are inverted, while the alpha channel is left alone.
    public var inverted: PixelColor {
        var pixel = self
        pixel.red = 1.0 - pixel.red
        pixel.green = 1.0 - pixel.green
        pixel.blue = 1.0 - pixel.blue
        return pixel
    }
    
    /// A pixel color object converted to grayscale. Similar with desaturated.
    /// - Parameter mode: Defines the mode (i.e color space) used for grayscaling.
    /// - Returns: A grayscale pixel color.
    public func grayscaled(mode: GrayedMode = .weighted) -> PixelColor {
        let lightness = mode.lightness(pixel: self)
        let (r, g, b) = PixelColor.HSL.toRGB(hue: 0, saturation: 0, lightness: lightness)
        let pixel = PixelColor.init(r: r, g: g, b: b, a: CGFloat(alpha))
        return pixel
    }
    
    /// A pixel color object with the saturation increased by the given amount.
    /// - Parameter amount: CGFloat between 0.0 and 1.0. Default value is 0.2.
    /// - Returns: A pixel color more saturated.
    public func saturated(amount: CGFloat = 0.2) -> PixelColor {
        HSL.saturation.adjusted(pixel: self, amount: amount)
    }
    
    /// A pixel color object with the saturation decreased by the given amount.
    /// - Parameter amount: CGFloat between 0.0 and 1.0. Default value is 0.2.
    /// - Returns: A pixel color less saturated.
    public func desaturated(amount: CGFloat = 0.2) -> PixelColor {
        saturated(amount: -amount)
    }
    
    /// A pixel color object with the lightness increased by the given amount.
    /// - Parameter amount: CGFloat between 0.0 and 1.0. Default value is 0.2.
    /// - Returns: A lighter pixel color.
    public func lighter(amount: CGFloat = 0.2) -> PixelColor {
        HSL.lightness.adjusted(pixel: self, amount: amount)
    }
    
    /// A pixel color object with the lightness decreased by the given amount.
    /// - Parameter amount: CGFloat between 0.0 and 1.0. Default value is 0.2.
    /// - Returns: A darker pixel color.
    public func darkened(amount: CGFloat = 0.2) -> PixelColor {
        lighter(amount: -amount)
    }
    
    /// A pixel color object with the hue rotated along the color wheel by the given amount.
    /// - Parameter amount: A float representing the number of degrees as ratio (usually between -360.0 degree and 360.0 degree).
    /// - Returns: A pixel color object with the hue changed.
    public func adjustedHue(amount: CGFloat) -> PixelColor {
        HSL.hue.adjusted(pixel: self, amount: amount)
    }
    
    /// A complement of the pixel color object.
    /// This is identical to adjustedHue 180.
    /// - Returns: The complement pixel color.
    public func complemented() -> PixelColor {
        return adjustedHue(amount: 180.0)
    }
}
