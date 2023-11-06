//
//  PixelColor.swift
//  PixelColor
//
//  Created by Condy on 2023/11/5.
//

import Foundation
import SwiftUI

/// RGBA色彩空间中的颜色，在`0 ~ 1`区间内
/// Pixel Color contains 4  channels, from 0 to 1.
public struct PixelColor {
    
    public static let zero = PixelColor(red: 0, green: 0, blue: 0, alpha: 0)
    public static let one  = PixelColor(red: 1, green: 1, blue: 1, alpha: 1)
    
    @ZeroOneRange public var red: Float
    @ZeroOneRange public var green: Float
    @ZeroOneRange public var blue: Float
    @ZeroOneRange public var alpha: Float
    
    /// Initializes and returns a pixel color object using the specified opacity and RGBA component values.
    /// - Parameters:
    ///   - red: The red component of the color object, specified as a value from 0.0 to 1.0.
    ///   - green: The green component of the color object, specified as a value from 0.0 to 1.0.
    ///   - blue: The blue component of the color object, specified as a value from 0.0 to 1.0.
    ///   - alpha: The opacity value of the color object, specified as a value from 0.0 to 1.0. Default to 1.0.
    public init(red: Float, green: Float, blue: Float, alpha: Float = 1.0) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    public init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
        self.init(red: Float(r), green: Float(g), blue: Float(b), alpha: Float(a))
    }
    
    public init(white: Float, alpha: Float = 1.0) {
        self.init(red: white, green: white, blue: white, alpha: alpha)
    }
    
    /// Initializes and returns a pixel color object with UIColor or NSColor.
    /// - Parameter color: A UIColor or NSColor object.
    public init(color: CrossPlatformColor) {
        var color = color
        #if os(macOS)
        /// Fixed `*** -getRed:green:blue:alpha: not valid for the NSColor Generic Gray Gamma 2.2 Profile colorspace 1 1;
        /// Need to first convert colorspace.
        /// See: https://stackoverflow.com/questions/67314642/color-not-valid-for-the-nscolor-generic-gray-gamma-when-creating-sktexture-fro
        color = color.usingColorSpace(.sRGB) ?? color
        #endif
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        // See: https://developer.apple.com/documentation/uikit/uicolor/1621919-getred
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        self.init(r: r, g: g, b: b, a: a)
    }
    
    /// Initializes and returns a pixel color object using the specified opacity and HSB component values.
    /// - Parameters:
    ///   - hue: The hue component of the color object, specified as a value from 0.0 to 360.0 degree.
    ///   - saturation: The saturation component of the color object, specified as a value from 0.0 to 1.0.
    ///   - brightness: The brightness component of the color object, specified as a value from 0.0 to 1.0.
    ///   - alpha: The opacity value of the color object, specified as a value from 0.0 to 1.0. Default to 1.0.
    public init(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat = 1.0) {
        let (r, g, b) = PixelColor.Converting.HSB2RGB(hue: hue, saturation: saturation, brightness: brightness)
        self.init(r: r, g: g, b: b, a: alpha)
    }
    
    /// Initializes and returns a pixel color object using the specified opacity and HSL component values.
    /// - Parameters:
    ///   - hue: The hue component of the color object, specified as a value from 0.0 to 360.0 degree.
    ///   - saturation: The saturation component of the color object, specified as a value from 0.0 to 1.0.
    ///   - lightness: The lightness component of the color object, specified as a value between 0.0 and 1.0.
    ///   - alpha: The opacity value of the color object, specified as a value from 0.0 to 1.0. Default to 1.0.
    public init(hue: CGFloat, saturation: CGFloat, lightness: CGFloat, alpha: CGFloat = 1.0) {
        let (r, g, b) = PixelColor.Converting.HSL2RGB(hue: hue, saturation: saturation, lightness: lightness)
        self.init(r: r, g: g, b: b, a: alpha)
    }
    
    /// Creates a pixel color from an hex integer, e.g. 0xD6A5A4.
    /// - Parameter hex: A hexa-decimal UInt64 that represents a color.
    public init(hex: Int) {
        let mask = 0xFF
        let r = Float((hex >> 16) & mask) / 255
        let g = Float((hex >> 8) & mask) / 255
        let b = Float((hex) & mask) / 255
        self.init(red: r, green: g, blue: b, alpha: 1)
    }
    
    /// Creates a pixel color from an hex string, e.g. "#D6A5A4".
    /// Support hex string `#RGB`,`RGB`,`#ARGB`,`ARGB`,`#RRGGBB`,`RRGGBB`,`#AARRGGBB`,`AARRGGBB`.
    /// - Parameter hex: A hexa-decimal color string representation.
    public init(hex: String) {
        let (r, g, b, a) = PixelColor.Converting.hexString2RGBA(hex: hex)
        self.init(r: r, g: g, b: b, a: a)
    }
}

extension PixelColor: Equatable {
    
    public static func == (lhs: PixelColor, rhs: PixelColor) -> Bool {
        lhs.red == rhs.red &&
        lhs.green == rhs.green &&
        lhs.blue == rhs.blue &&
        lhs.alpha == rhs.alpha
    }
}

extension PixelColor {
    
    public func toColor() -> CrossPlatformColor {
        CrossPlatformColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }
    
    @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
    public func toColor() -> Color {
        Color(red: Double(red), green: Double(green), blue: Double(blue), opacity: Double(alpha))
    }
    
    /// Returns the color representation as hexadecimal string.
    /// - Parameter alphaChannel: Does it include transparent channels.
    /// - Returns: return hexadecimal string as `#AARRGGBB` or `#RRGGBB`
    public func toHex(contain alphaChannel: Bool = false) -> String {
        func hexa(_ v: Float) -> String {
            let value = UInt8(v * 255)
            return (value < 16 ? "0" : "") + String(value, radix: 16, uppercase: true)
        }
        if alphaChannel {
            return "#" + hexa(alpha) + hexa(red) + hexa(green) + hexa(blue)
        } else {
            return "#" + hexa(red) + hexa(green) + hexa(blue)
        }
    }
}
