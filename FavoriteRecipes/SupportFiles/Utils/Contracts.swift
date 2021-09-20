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


protocol PersistableRecipe {
    var id: String { get set }
    var title: String { get set }
    var imageUrl: String { get set }
    var isFavorite: String { get set }
}


protocol RecipeServiceProtocol {
    func fetchRx<T: Codable>() -> Observable<T>
}
