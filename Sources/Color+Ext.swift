//
//  Color+Ext.swift
//  PixelColor
//
//  Created by Condy on 2023/11/5.
//

import Foundation
import SwiftUI

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
public typealias CrossPlatformColor = UIColor
#elseif os(macOS)
import AppKit
public typealias CrossPlatformColor = NSColor
#endif

extension CrossPlatformColor: PixelColorCompatible {
    
    /// Creates a color from an hex integer, e.g. 0xD6A5A4.
    /// - Parameter hex: A hexa-decimal UInt64 that represents a color.
    public convenience init(hex: Int) {
        let components = PixelColor(hex: hex).components
        self.init(red: components[0], green: components[1], blue: components[2], alpha: components[3])
    }
    
    /// Creates a color from an hex string, e.g. "#D6A5A4".
    /// Support hex string `#RGB`,`RGB`,`#ARGB`,`ARGB`,`#RRGGBB`,`RRGGBB`,`#AARRGGBB`,`AARRGGBB`.
    /// - Parameter hex: A hexa-decimal color string representation.
    public convenience init(hex: String) {
        let components = PixelColor(hex: hex).components
        self.init(red: components[0], green: components[1], blue: components[2], alpha: components[3])
    }
}

// MARK: - UIColor / NSColor
extension PixelColorWrapper where Base: CrossPlatformColor {
    /// Convert pixel color value
    public func toPixelColor() -> PixelColor {
        PixelColor(color: base)
    }
}

// MARK: - SwiftUI Color
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
extension Color: PixelColorCompatible {
    
    /// Creates a color from an hex integer, e.g. 0xD6A5A4.
    /// - Parameter hex: A hexa-decimal UInt64 that represents a color.
    public init(hex: Int) {
        let components = PixelColor(hex: hex).components
        self.init(red: components[0], green: components[1], blue: components[2], opacity: components[3])
    }
    
    /// Creates a color from an hex string, e.g. "#D6A5A4".
    /// Support hex string `#RGB`,`RGB`,`#ARGB`,`ARGB`,`#RRGGBB`,`RRGGBB`,`#AARRGGBB`,`AARRGGBB`.
    /// - Parameter hex: A hexa-decimal color string representation.
    public init(hex: String) {
        let components = PixelColor(hex: hex).components
        self.init(red: components[0], green: components[1], blue: components[2], opacity: components[3])
    }
}

extension PixelColorWrapper where Base == Color {
    
    /// Convert pixel color value
    public func toPixelColor() -> PixelColor? {
        if #available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *) {
            let color = CrossPlatformColor.init(base)
            return PixelColor(color: color)
        }
        if let (r, g, b, a) = components() {
            return PixelColor.init(r: r, g: g, b: b, a: a)
        }
        return nil
    }
    
    private func components() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)? {
        let hex = { (val: String) -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) in
            var components: [CGFloat] = Array.init(repeating: 0, count: 4)
            for index in stride(from: 1, to: val.count - 1, by: 2) {
                let r1 = val.index(val.startIndex, offsetBy: index)
                let r2 = val.index(val.startIndex, offsetBy: index + 1)
                let r = CGFloat(Int(val[r1...r2], radix: 16) ?? 0) / 255.0
                components[index/2] = r
            }
            return (components[0], components[1], components[2], components[3])
        }
        if let val = hexRepresentation, val.hasPrefix("#") {
            return hex(val)
        }
        if base.description.hasPrefix("#") {
            return hex(base.description)
        }
        return nil
    }
    
    private var hexRepresentation: String? {
        let children = Mirror(reflecting: base).children
        let _provider = children.filter { $0.label == "provider" }.first
        guard let provider = _provider?.value else {
            return nil
        }
        let providerChildren = Mirror(reflecting: provider).children
        let _base = providerChildren.filter { $0.label == "base" }.first
        guard let base = _base?.value else {
            return nil
        }
        var baseValue: String = ""
        dump(base, to: &baseValue)
        guard let firstLine = baseValue.split(separator: "\n").first,
              let hexString = firstLine.split(separator: " ")[1] as Substring? else {
            return nil
        }
        return hexString.trimmingCharacters(in: .newlines)
    }
}
