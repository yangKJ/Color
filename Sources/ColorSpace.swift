//
//  ColorSpace.swift
//  PixelColor
//
//  Created by Condy on 2023/11/5.
//

import Foundation

extension PixelColor {
    
    /// Defines the supported color spaces.
    public enum ColorSpace {
        /// RGB is a space defined by the color recognized by the human eye, which can represent most colors.
        /// It is the most basic, commonly used and hardware-oriented color space in image processing. It is a light mixing system.
        case rgb
        /// HSI color space is a human visual system that describes color by hue, saturation or Chroma and intensity.
        /// H: Indicates the phase angle of the color. Red, green and blue are 120 degrees apart respectively, complementary colors are 180 degrees apart.
        /// S: Represents the ratio between the purity of the selected color and the maximum purity of the color. A range of `0` to `1`.
        /// I: Indicates the lightness of the color, a range of `0` to `1`.
        case hsl
        /// HSB color space is a human visual system that describes color by hue, saturation or Chroma and intensity.
        /// H: Indicates the phase angle of the color. Red, green and blue are 120 degrees apart respectively, complementary colors are 180 degrees apart.
        /// S: Represents the ratio between the purity of the selected color and the maximum purity of the color. A range of `0` to `1`.
        /// B: Indicates the brightness of the color, a range of `0` to `1`.
        case hsb
        /// CMYK is a color mode that relies on reflective light.
        /// How do we read the content of newspapers?
        /// It is the sunlight or light that shines on the newspaper and then reflects it into our eyes to see the content.
        /// It needs an external light source, and you can't read the newspaper if you are in a dark room.
        /// As long as the image displayed on the screen is represented by RGB mode.
        /// As long as the image is seen in the print, it is represented by CMYK mode.
        /// Most devices that deposit color pigments on paper, such as color printers and copiers, require the input of CMY data and the conversion of RGB to CMY internally.
        //case cmyk
    }
}
