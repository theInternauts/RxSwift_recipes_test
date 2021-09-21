//
//  PersistenceManagerLight.swift
//  FavoriteRecipes
//
//  Created by Christopher Wallace on 9/21/21.
//

import UIKit


class PersistenceManagerLight {
    private static let privateManagerForConfiguration: PersistenceManagerLight = { return PersistenceManagerLight() }()
    
    
    // MARK: - Initialization
    private init() {}
    
    
    // MARK: - Accessors
    class func shared() -> PersistenceManagerLight {
        return privateManagerForConfiguration
    }
    
    // MARK: - Public
    func storeRecipeFavoritableObjectToUserDefault(_ model: PersistableRecipeModel, completion: (() -> Void)? = nil) {
        print("========== SAVING ==========================================")
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: model, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: model.id)
            guard completion != nil else {
                return
            }
            completion!()
        } catch(let error) {
            print(APIErrors.persistenceSaveError(error).extendedMessage)
        }
    }
    
    func getRecipeObjectFromUserDefault(_ id: String) -> PersistableRecipeModel? {
        var model: PersistableRecipeModel?
        do {
            if let data = UserDefaults.standard.value(forKey: id) {
                model = try NSKeyedUnarchiver.unarchivedObject(ofClass: PersistableRecipeModel.self, from: data as! Data)
                print("retrieved ==> \(String(describing: model?.id)): \(String(describing: model?.title)): \(String(describing: model?.isFavorite))")
            }
        } catch(let error) {
            model = nil
            print(APIErrors.persistenceSaveError(error).extendedMessage)
        }
        return model
    }
    
    func deleteRecipeObjectFromUserDefault(_ id: String, completion: (() -> Void)? = nil) {
        print("````````````````````` DELETING ```````````````````````")
        UserDefaults.standard.removeObject(forKey: id)
        guard completion != nil else {
            return
        }
        completion!()
    }
}
