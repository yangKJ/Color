# PixelColor

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-brightgreen.svg?style=flat&colorA=28a745&&colorB=4E4E4E)](https://github.com/yangKJ/PixelColor)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/PixelColor.svg?style=flat&label=PixelColor&colorA=28a745&&colorB=4E4E4E)](https://cocoapods.org/pods/PixelColor)
![Platform](https://img.shields.io/badge/Platforms-iOS%20%7C%20macOS%20%7C%20watchOS-4E4E4E.svg?colorA=28a745)

🎨. [**PixelColor**](https://github.com/yangKJ/PixelColor) is a pixel color extension with Swift and SwiftUI.

<p align="left">
<img src="https://raw.githubusercontent.com/yangKJ/PixelColor/master/Screenshot/Test.png" width=30% hspace="1px">
<img src="https://raw.githubusercontent.com/yangKJ/PixelColor/master/Screenshot/Test2.png" width=30% hspace="15px">
</p> 

## Requirements

| iOS Target | macOS Target | Xcode Version | Swift Version |
|:---:|:---:|:---:|:---:|
| iOS 10.0+ | macOS 10.13+ | Xcode 10.0+ | Swift 5.0+ |

## Usage

#### Creation (Hex String)

Firstly, Provides useful initializers to create colors using hex strings or values:

```swift
let color = UIColor.init(hex: "#3498DB")
// equivalent to
// color = UIColor.init(hex: 0x3498DB)
```

To be platform independent, the typealias `CrossPlatformColor` can also be used:

```swift
let color = CrossPlatformColor.init(hex: "#3498DB")
// On iOS, WatchOS or tvOS, equivalent to
// color = UIColor.init(hex: "#3498DB")
// On OSX, equivalent to
// color = NSColor.init(hex: "#3498DB")
```

You can also retrieve the RGBA value and components very easily using multiple methods like `toHex`, `toRGBA`, etc.

##### SwiftUI

From the v5, Also support basic methods to create and manipulate colors with SwiftUI.

```swift
let color = Color.init(hex: "#3498DB")
```

#### Darken & Lighten

These two create a new pixel color by adjusting the lightness of the receiver.

<p align="left">
  <img src="http://yannickloriot.com/resources/dynamiccolor-darkenlighten.png" alt="lighten and darken color" width="280"/>
</p>

```swift
let pixel = PixelColor.init(hex: "#C0392B")

let lighter = pixel.lighter()
// equivalent to
// lighter = pixel.lighter(amount: 0.2)

let darker = pixel.darkened()
// equivalent to
// darker = pixel.darker(amount: 0.2)
```

#### Saturate, Desaturate & Grayscale

These will adjust the saturation of the pixel color object, much like `darkened` and `lighter` adjusted the lightness. 

Again, you need to use a value between 0 and 1.

<p align="left">
  <img src="http://yannickloriot.com/resources/dynamiccolor-saturateddesaturatedgrayscale.png" alt="saturate, desaturate and grayscale color" width="373"/>
</p>

```swift
let pixel = PixelColor.init(hex: "#C0392B")

let saturated = pixel.saturated()
// equivalent to
// saturated = pixel.saturated(amount: 0.2)

let desaturated = pixel.desaturated()
// equivalent to
// desaturated = pixel.desaturated(amount: 0.2)

// equivalent to
// let grayscaled = pixel.grayscaled(mode: .weighted)
let grayscaled = pixel.grayscaled()
```

#### Adjust Hue & Complement

These adjust the hue value of the color in the same way like the others do. Again, it takes a value between 0 and 1 to update the value.

<p align="left">
  <img src="http://yannickloriot.com/resources/dynamiccolor-adjustedhuecomplement.png" alt="ajusted-hue and complement color" width="280"/>
</p>

```swift
let pixel = PixelColor.init(hex: "#C0392B")

// Hue values are in degrees
let adjustHue = pixel.adjustedHue(amount: 45)

let complemented = pixel.complemented()
// equivalent to
// complemented = pixel.adjustedHue(amount: 180)
```

#### Tint & Shade

A tint is the mixture of a pixel color with white and a shade is the mixture of a pixel color with black. 

Again, it takes a value between 0 and 1 to update the value.

<p align="left">
<img src="http://yannickloriot.com/resources/dynamiccolor-tintshadecolor.png" alt="tint and shade color" width="280"/>
</p>

```swift
let pixel = PixelColor.init(hex: "#C0392B")

let tinted = pixel.tinted()
// equivalent to
// tinted = pixel.tinted(amount: 0.2)

let shaded = pixel.shaded()
// equivalent to
// shaded = pixel.shaded(amount: 0.2)
```

#### Invert

This can invert the pixel color object. The red, green, and blue values are inverted, while the opacity is left alone.

<p align="left">
  <img src="http://yannickloriot.com/resources/dynamiccolor-invert.png" alt="invert color" width="187"/>
</p>

```swift
let pixel = PixelColor.init(hex: "#C0392B")

let inverted = pixel.inverted()
```

#### Mixing

This can mix a given pixel color with the receiver. 

It takes the average of each of the RGB components, optionally weighted by the given percentage (value between 0 and 1).

<p align="left">
<img src="http://yannickloriot.com/resources/dynamiccolor-mixcolor.png" alt="mix color" width="373"/>
</p>

```swift
let pixel = PixelColor.init(hex: "#C0392B")

let mixed = pixel.mixed(other: .blue)
// equivalent to
// mixed = pixel.mixed(weight: 0.5, other: .blue)
// or
// mixed = pixel.mixed(in: .rgb, weight: 0.5, other: .blue)
```

### CocoaPods

- If you want to import [**PixelColor**](https://github.com/yangKJ/PixelColor) module, you need in your Podfile: 

```
pod 'PixelColor'
```

### Swift Package Manager

[Swift Package Manager](https://swift.org/package-manager/) is a tool for managing the distribution of Swift code. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

> Xcode 11+ is required to build [PixelColor](https://github.com/yangKJ/PixelColor) using Swift Package Manager.

To integrate PixelColor into your Xcode project using Swift Package Manager, add it to the dependencies value of your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/yangKJ/PixelColor.git", branch: "master"),
]
```

### Remarks

> The general process is almost like this, the Demo is also written in great detail, you can check it out for yourself.🎷
>
> [**PixelColorDemo**](https://github.com/yangKJ/PixelColor)
>
> Tip: If you find it helpful, please help me with a star. If you have any questions or needs, you can also issue.
>
> Thanks.🎇

### About the author
- 🎷 **E-mail address: [yangkj310@gmail.com](yangkj310@gmail.com) 🎷**
- 🎸 **GitHub address: [yangKJ](https://github.com/yangKJ) 🎸**

Buy me a coffee or support me on [GitHub](https://github.com/sponsors/yangKJ?frequency=one-time&sponsor=yangKJ).

<a href="https://www.buymeacoffee.com/yangkj3102">
<img width=25% alt="yellow-button" src="https://user-images.githubusercontent.com/1888355/146226808-eb2e9ee0-c6bd-44a2-a330-3bbc8a6244cf.png">
</a>

Alipay or WeChat. Thanks.

<p align="left">
<img src="https://raw.githubusercontent.com/yangKJ/PixelColor/master/Screenshot/WechatIMG1.jpg" width=30% hspace="1px">
<img src="https://raw.githubusercontent.com/yangKJ/PixelColor/master/Screenshot/WechatIMG2.jpg" width=30% hspace="15px">
</p>

-----

### License
PixelColor is available under the [MIT](LICENSE) license. See the [LICENSE](LICENSE) file for more info.

-----
