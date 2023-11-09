import XCTest
import SwiftUI
@testable import PixelColor

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
final class PixelColorTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let pixel = PixelColor.init(red: 50, green: 2, blue: 3)
        XCTAssertNotNil(pixel)
    }
    
    // 测试HSB生成是否正确
    func testHSB() throws {
        let color = CrossPlatformColor.init(hex: "#D6A5A4")
        
        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        hue *= 360
        
        let pixel = PixelColor.init(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
        let pixel2 = PixelColor.init(color: color)
        
        print("HSB: - \(pixel2.toHSBComponents())")
        print("HSB: - \([hue, saturation, brightness])")
        
        XCTAssertEqual(pixel.toHex(), pixel2.toHex())
        XCTAssertEqual(pixel.components, pixel2.components)
    }
    
    @available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
    func testSwiftUIColorAndCrossPlatformColor() {
        let uicolor = CrossPlatformColor.init(hex: "#D6A5A4")
        let color = Color.init(hex: "#D6A5A4")
        
        let pixel = PixelColor.init(color: uicolor)
        let pixel2 = PixelColor.init(color: color)
        
        XCTAssertEqual(pixel.toHex(), pixel2.toHex())
    }
}
