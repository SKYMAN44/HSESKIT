//
//  File.swift
//  
//
//  Created by Дмитрий Соколов on 22.02.2022.
//

import Foundation
import UIKit

public enum InterFonts: String, CaseIterable {
    case bold = "Inter-Bold"
    case medium = "Inter-Medium"
    case regular = "Inter-Regular"
    case semibold = "Inter-SemiBold"
}


public enum SFMonoFonts: String {
    case medium = "SFMonoMedium"
}

public struct HSESKIT {
    fileprivate static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) {
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension),
            let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
            let font = CGFont(fontDataProvider) else {
                fatalError("Couldn't create font from filename: \(fontName) with extension \(fontExtension)")
        }
        var error: Unmanaged<CFError>?

        CTFontManagerRegisterGraphicsFont(font, &error)
    }
    
    public static func registerFonts() {
        InterFonts.allCases.forEach {
            registerFont(bundle: .module, fontName: $0.rawValue, fontExtension: "ttf")
        }
        registerFont(bundle: .module, fontName: SFMonoFonts.medium.rawValue, fontExtension: "otf")
    }
}
