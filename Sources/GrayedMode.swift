//
//  GrayedMode.swift
//  PixelColor
//
//  Created by Condy on 2023/11/5.
//

import Foundation

extension PixelColor {
    
    /// Defines the mode (i.e color space) used for grayscaling.
    /// https://en.wikipedia.org/wiki/Lightness#Lightness_and_human_perception
    public enum GrayedMode {
        /// Weighted average method: The weighted average in RGB is used as gray.
        /// Because the human eye is sensitive to red, green and blue, it is necessary to calculate the grayscale.
        /// This coefficient is mainly derived according to the sensitivity of the human eye to the three primary colors of R, G and B.
        case weighted
        /// HSL lightness
        case lightness
        /// Average method: RGB average value as gray.
        case average
        /// Maximum method: the maximum value in RGB as gray.
        case maximum
    }
}

extension PixelColor.GrayedMode {
    
    func lightness(pixel: PixelColor) -> CGFloat {
        let r = CGFloat(pixel.red)
        let g = CGFloat(pixel.green)
        let b = CGFloat(pixel.blue)
        switch self {
        case .weighted:
            return (0.299 * r) + (0.587 * g) + (0.114 * b)
        case .lightness:
            return 0.5 * (max(r, g, b) + min(r, g, b))
        case .average:
            return (r + g + b) / 3.0
        case .maximum:
            return max(r, g, b)
        }
    }
}
