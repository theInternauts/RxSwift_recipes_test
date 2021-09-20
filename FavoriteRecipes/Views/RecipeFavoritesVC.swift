//
//  RecipeFavoritesVC.swift
//  FavoriteRecipes
//
//  Created by Christopher Wallace on 9/20/21.
//

import UIKit
import RxSwift
import RxCocoa


class RecipeFavoritesVC: UIViewController {
    let tabBarItemLabelText: String
    let tabBarItemIconActive: UIImage
    let tabBarItemIconInactive: UIImage
    
    
    // MARK: - Initialization
    init(tabBarItemLabelText: String,
         tabBarItemIconActive: UIImage,
         tabBarItemIconInactive: UIImage) {
        
        self.tabBarItemLabelText = tabBarItemLabelText
        self.tabBarItemIconActive = tabBarItemIconActive
        self.tabBarItemIconInactive = tabBarItemIconInactive
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureNavigation(isHidden: false, textColor: Colors.gray)
    }
}


// MARK: PRIVATE - RecipeFavoritesVC
private extension RecipeFavoritesVC {
    func configureUI() -> Void {
        configureNavigation(isHidden: false, textColor: Colors.gray)
        view.backgroundColor = .systemBackground
        navigationItem.backButtonDisplayMode = .minimal
        title = LocalizedText.favorites.rawValue
        navigationItem.title = LocalizedText.favorites.rawValue
    }
    
    func configureNavigation(isHidden: Bool, textColor: UIColor = Colors.gray) -> Void {
        navigationController?.navigationBar.isHidden = isHidden
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:textColor]
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = textColor
    }
}


// MARK: UITabBarEnabled
extension RecipeFavoritesVC: UITabBarEnabled {}
