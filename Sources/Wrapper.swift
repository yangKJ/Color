//
//  Wrapper.swift
//  PixelColor
//
//  Created by Condy on 2023/11/5.
//

import Foundation

/// Add the `px` prefix namespace
public struct PixelColorWrapper<Base> {
    public let base: Base
}

/// Protocol describing the `px` extension points for Alamofire extended types.
public protocol PixelColorCompatible { }

extension PixelColorCompatible {
    
    public var px: PixelColorWrapper<Self> {
        get { return PixelColorWrapper(base: self) }
        set { }
    }
    
    public static var px: PixelColorWrapper<Self>.Type {
        PixelColorWrapper<Self>.self
    }
}
