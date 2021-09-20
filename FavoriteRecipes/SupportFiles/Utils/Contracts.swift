//
//  Contracts.swift
//  FavoriteRecipes
//
//  Created by Christopher Wallace on 9/20/21.
//

import UIKit
import RxSwift


protocol UITabBarEnabled: UIViewController {
    var tabBarItemLabelText: String { get }
    var tabBarItemIconActive: UIImage { get }
    var tabBarItemIconInactive: UIImage { get }
}
