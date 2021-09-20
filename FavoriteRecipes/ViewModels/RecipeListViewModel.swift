//
//  RecipeListViewModel.swift
//  FavoriteRecipes
//
//  Created by Christopher Wallace on 9/20/21.
//

import UIKit
import RxSwift
import RxCocoa


class RecipeListViewModel {
    var title = ApplicationText.recipes.rawValue
    
    var recipes: Observable<[Recipe]>?
    var recipeDetailObserver: Observable<[RecipeDetailViewModel]> {
        return recipeDetail.asObservable()
    }
    
    private let recipeDetail = BehaviorRelay<[RecipeDetailViewModel]>(value: [])
    private var service: RecipeServiceProtocol!
    private let bag = DisposeBag()
    
    
    // MARK: - Initialization
    init(service: RecipeServiceProtocol = RxHTTPService.shared()) {
        self.service = service
    }
    
    func fetchRecipeViewModels() {
        recipes = service.fetchRx()
        recipes?.subscribe(onNext: { value in
            var recipeDetailViewModels = [RecipeDetailViewModel]()
            for index in 0..<value.count {
                let detail = RecipeDetailViewModel(recipe: value[index])
                self.readFavoritesStatus(detail)
                recipeDetailViewModels.append(detail)
            }
            self.recipeDetail.accept(recipeDetailViewModels)
        },
        onError: { error in
            _ = self.recipeDetail.catch({ error in
                print(APIErrors.fetchError(error).extendedMessage)
                return Observable<[RecipeDetailViewModel]>.empty()
            })
        },
        onCompleted: {
            print("fetch complete")
        }).disposed(by: bag)
    }
    
    func readFavoritesStatus(_ model: RecipeDetailViewModel) -> Void {
        if let prm = PersistenceManagerLight.shared().getRecipeObjectFromUserDefault(model.id) {
            model.isFavorite.accept(Bool(prm.isFavorite) ?? false)
        }
    }
    
    func updateFavoritesStatus(_ model: RecipeDetailViewModel, completion: (()-> Void)? = nil) -> Void {
        if model.isFavorite.value {
            PersistenceManagerLight.shared().storeRecipeFavoritableObjectToUserDefault(PersistableRecipeModel(model))
        } else {
            PersistenceManagerLight.shared().deleteRecipeObjectFromUserDefault(model.id)
        }
        guard completion != nil else {
            return
        }
        completion!()
    }
}
