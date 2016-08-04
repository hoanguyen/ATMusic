//
//  Fonts.swift
//  EParkRelax
//
//  Created by DaoNV on 3/7/16.
//  Copyright © 2016 AsianTech Inc. All rights reserved.
//

import Foundation
import UIKit
import SwiftUtils

// MARK: - Custom Font Table
/*
 Example: label.font = Font(.Lato, .Bold, 12)
 */

struct Font {

    static var Helvetica = HelveticaFont()

    static func preloads(completion: (() -> Void)?) {
        dp_background { () -> Void in
            Helvetica.Regular(14)
            completion?()
        }
    }

}

class HelveticaFont: CustomFont {
    override var name: FontName! {
        return .Helvetica
    }

    func Regular(fontSize: CGFloat) -> UIFont! {
        return CCFont(name, .None, fontSize)
    }

    func Light(fontSize: CGFloat) -> UIFont! {
        return CCFont(name, .Light, fontSize)
    }
}

enum FontName: String {
    case Helvetica = "Helvetica"

    var familyName: String {
        switch self {
        case .Helvetica: return "Helvetica"
        }
    }
}

enum FontType: String {
    case Black = "-Black"
    case BlackItalic = "-BlackItalic"
    case Bold = "-Bold"
    case BoldItalic = "-BoldItalic"
    case ExtraBold = "-ExtraBold"
    case ExtraBoldItalic = "-ExtraBoldItalic"
    case Hairline = "-Hairline"
    case HairlineItalic = "-HairlineItalic"
    case Heavy = "-Heavy"
    case HeavyItalic = "-HeavyItalic"
    case Italic = "-Italic"
    case Light = "-Light"
    case LightItalic = "-LightItalic"
    case Medium = "-Medium"
    case MediumItalic = "-MediumItalic"
    case Regular = "-Regular"
    case Semibold = "-Semibold"
    case SemiboldItalic = "-SemiboldItalic"
    case Thin = "-Thin"
    case ThinItalic = "-ThinItalic"
    case Ultra = "-Ultra"
    case None = ""
}

enum PSDFontScale: CGFloat {
    case Phone45 = 0.9
    case Phone6 = 1.0
    case Phone6p = 1.2
    case IPad = 1.3
}

let fontScale = loadFontScale()

func loadFontScale() -> CGFloat {
    return Ratio.width
}

func CCFont(name: FontName, _ type: FontType, _ size: CGFloat) -> UIFont! {
    let fontName = name.rawValue + type.rawValue
    let fontSize = size * fontScale
    let font = UIFont(name: fontName, size: fontSize)
    if let font = font {
        return font
    } else {
        print("\(fontName) is invalid font.")
        return UIFont.systemFontOfSize(fontSize)
    }
}

class CustomFont {
    var name: FontName! { return nil }
    init() { }
    var description: String {
        if let name = name {
            let fonts = UIFont.fontNamesForFamilyName(name.familyName)
            return "\(fonts)"
        }
        return ""
    }
}
