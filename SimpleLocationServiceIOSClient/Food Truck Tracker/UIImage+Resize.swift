//
//  UIImage+Resize.swift
//  Food Truck Tracker
//
//  Created by Prabhu Swaminathan on 01/05/17.
//  Copyright © 2017 Drivebook. All rights reserved.
//
import UIKit
import Foundation

extension UIImage {
    func imageResize (sizeChange:CGSize)-> UIImage{
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
}
