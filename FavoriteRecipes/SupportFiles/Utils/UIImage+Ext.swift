//
//  UIImage+Ext.swift
//  FavoriteRecipes
//
//  Created by Christopher Wallace on 9/21/21.
//

import UIKit


// MARK: - Layout Utilities
extension UIImage
{
   func resizedImage(size sizeImage: CGSize) -> UIImage?
   {
       let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: sizeImage.width, height: sizeImage.height))
       UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
       self.draw(in: frame)
       let resizedImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
       UIGraphicsEndImageContext()
       self.withRenderingMode(.alwaysOriginal)
       return resizedImage
   }
}
