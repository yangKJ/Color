//
//  ContrastDisplayContext.swift
//  PixelColor
//
//  Created by Condy on 2023/11/5.
//

import Foundation

extension PixelColor {
    
    /// Used to describe the context of display of 2 colors.
    /// https://www.w3.org/TR/2008/REC-WCAG20-20081211/#visual-audio-contrast-contrast
    public enum ContrastDisplayContext {
        /// A standard text in a normal context.
        case standard
        /// A large text in a normal context.
        /// https://www.w3.org/TR/2008/REC-WCAG20-20081211/#larger-scaledef
        case standardLargeText
        /// A standard text in an enhanced context.
        case enhanced
        /// A large text in an enhanced context.
        /// https://www.w3.org/TR/2008/REC-WCAG20-20081211/#larger-scaledef
        case enhancedLargeText
    }
}

extension PixelColor.ContrastDisplayContext {
    
    var minimumContrastRatio: CGFloat {
        switch self {
        case .standard:
            return 4.5
        case .standardLargeText:
            return 3.0
        case .enhanced:
            return 7.0
        case .enhancedLargeText:
            return 4.5
        }
    }
}
