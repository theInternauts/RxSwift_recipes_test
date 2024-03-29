//
//  RecipeDetailViewModel.swift
//  FavoriteRecipes
//
//  Created by Christopher Wallace on 9/20/21.
//

import UIKit
import RxSwift
import RxCocoa


struct RecipeDetailViewModel {
    // TODO: - refactor the entire model and expose recipe as
    // an observerable on the public interface
    
    // THIS FILE MAKES ME SAD!
    
    var recipe: Recipe!
    
    var id: String { return recipe.id }
    var title: String { return recipe.attributes.title }
    var imageUrl: String { return recipe.attributes.thumbnailSquareUrl }
    var isFavorite: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var isFavoriteObservable: Observable<Bool> {
        return isFavorite.asObservable()
    }
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
}
