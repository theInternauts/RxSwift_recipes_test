//
//  RecipeAppTabVC.swift
//  FavoriteRecipes
//
//  Created by Christopher Wallace on 9/20/21.
//

import UIKit

class RecipeAppTabVC: UITabBarController {
    var recipeListing: UITabBarEnabled
    var recipeFavorites: UITabBarEnabled
    
   init(listing: UITabBarEnabled, favorites: UITabBarEnabled) {
        self.recipeListing = listing
        self.recipeFavorites = favorites
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

private extension RecipeAppTabVC {
    func configureUI() -> Void {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        view.backgroundColor = .white
        tabBar.barTintColor = .white
        tabBar.tintColor = Colors.gold
        tabBar.unselectedItemTintColor = Colors.gray
        
        recipeListing.tabBarItem = UITabBarItem(title: recipeListing.tabBarItemLabelText,
                                                image: recipeListing.tabBarItemIconInactive,
                                                selectedImage: recipeListing.tabBarItemIconActive)
        
        recipeFavorites.tabBarItem = UITabBarItem(title: recipeFavorites.tabBarItemLabelText,
                                                  image: recipeFavorites.tabBarItemIconInactive,
                                                  selectedImage: recipeFavorites.tabBarItemIconActive)
        
        setViewControllers([recipeListing, recipeFavorites], animated: true)
    }
}
