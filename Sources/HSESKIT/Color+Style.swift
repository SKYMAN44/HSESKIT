//
//  File.swift
//  
//
//  Created by Дмитрий Соколов on 22.02.2022.
//

import Foundation
import UIKit

// guard case if case
extension UIColor {
    public enum background {
        case firstLevel
        case secondLevel
        case accent
        
        func style() -> UIColor {
            let color: UIColor
            switch self {
            case .accent:
                color = UIColor(named: "BackgroundAccent")!
            case .firstLevel:
                color = UIColor(named: "BackgroundFirstLevel")!
            case .secondLevel:
                color = UIColor(named: "BackgroundSeccondLevel")!
            }
            return color
        }
    }
    
    public enum outline {
        case heavy
        case light
        
        func style() -> UIColor {
            let color: UIColor
            switch self {
            case .heavy:
                color = UIColor(named: "OutlineHeavy")!
            case .light:
                color = UIColor(named: "OutlineLight")!
            }
            return color
        }
    }
    
    public enum primary {
        case onPrimary
        case primary
        case filler
        
        func style() -> UIColor {
            let color: UIColor
            switch self {
            case .onPrimary:
                color = UIColor(named: "onPrimary")!
            case .primary:
                color = UIColor(named: "Primary")!
            case .filler:
                color = UIColor(named: "PrimaryFiller")!
            }
            return color
        }
    }
    
    public enum special {
        case accept
        case aceptFiller
        case warning
        case warningFiller
        
        func style() -> UIColor {
            let color: UIColor
            switch self {
            case .accept:
                color = UIColor(named: "Accept")!
            case .aceptFiller:
                color = UIColor(named: "AcceptFiller")!
            case .warning:
                color = UIColor(named: "Warning")!
            case .warningFiller:
                color = UIColor(named: "WarningFiller")!
            }
            return color
        }
    }
    
    public enum textAndIcons {
        case primary
        case secondary
        case tretiary
        
        func style() -> UIColor {
            let color: UIColor
            switch self {
            case .primary:
                color = UIColor(named: "Text&IconsPrimary")!
            case .secondary:
                color = UIColor(named: "Text&IconsSecondary")!
            case .tretiary:
                color = UIColor(named: "Text&IconsTretiary")!
            }
            return color
        }
    }
}
