//
//  GrayscalingMode.swift
//  PixelColor
//
//  Created by Condy on 2023/11/5.
//

import Foundation

extension PixelColor {
    
    /// Defines the mode (i.e color space) used for grayscaling.
    /// https://en.wikipedia.org/wiki/Lightness#Lightness_and_human_perception
    public enum GrayscalingMode {
        /// XYZ luminance
        case luminance
        /// HSL lightness
        case lightness
        /// RGB average
        case average
        /// HSV value
        case value
    }
}

extension PixelColor.GrayscalingMode {
    
    func lightness(pixel: PixelColor) -> CGFloat {
        let r = CGFloat(pixel.red)
        let g = CGFloat(pixel.green)
        let b = CGFloat(pixel.blue)
        switch self {
        case .luminance:
            return (0.299 * r) + (0.587 * g) + (0.114 * b)
        case .lightness:
            return 0.5 * (max(r, g, b) + min(r, g, b))
        case .average:
            return (1.0 / 3.0) * (r + g + b)
        case .value:
            return max(r, g, b)
        }
    }
}
