//
//  UILabel+Ext.swift
//  FavoriteRecipes
//
//  Created by Christopher Wallace on 9/21/21.
//

import UIKit


// MARK: - Layout Utilities
extension UILabel {
    // credit: https://medium.com/flawless-app-stories/spacing-between-each-character-in-uilabel-swift-ios-7c7e61cacb59
    // adding even space between each characters (tracking)
    func addCharacterTracking(_ trackingValue: Double = 5) {
        if let labelText = self.text, labelText.isEmpty == false {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(.kern,
                                          value: trackingValue,
                                          range: NSRange(location: 0, length: attributedString.length - 1))
            self.attributedText = attributedString
        }
    }
}

