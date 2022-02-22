//
//  File.swift
//  
//
//  Created by Дмитрий Соколов on 23.02.2022.
//

import Foundation
import UIKit

extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}

extension UIImage {
    func clone() -> UIImage? {
        guard let originalCgImage = self.cgImage,
              let newCgImage = originalCgImage.copy()
        else {
            return nil
        }
        return UIImage(cgImage: newCgImage, scale: self.scale, orientation: self.imageOrientation)
    }
}
