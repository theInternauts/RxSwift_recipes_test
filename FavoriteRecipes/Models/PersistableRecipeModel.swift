//
//  PersistableRecipeModel.swift
//  FavoriteRecipes
//
//  Created by Christopher Wallace on 9/21/21.
//

import UIKit


class PersistableRecipeModel: NSObject, NSSecureCoding, NSCoding, PersistableRecipe {
    static var supportsSecureCoding: Bool = true
    
    var id: String
    var title: String
    var imageUrl: String
    var isFavorite: String
    internal var storedAt: String
    
    init(id: String, title: String, imageUrl: String, isFavorite: String = "0") {
        self.id = id
        self.title = title
        self.imageUrl = imageUrl
        self.isFavorite = isFavorite
        self.storedAt = String(NSDate().timeIntervalSince1970)
    }
    
    required convenience init?(coder: NSCoder) {
        
        guard let id = coder.decodeObject(of: NSString.self, forKey: "id") as String?,
              let title = coder.decodeObject(of: NSString.self, forKey: "title") as String?,
              let imageUrl = coder.decodeObject(of: NSString.self, forKey: "imageUrl") as String?,
              let isFavorite = coder.decodeObject(of: NSString.self, forKey: "isFavorite") as String?
        else { return nil }
        
        self.init(id: id, title: title, imageUrl: imageUrl, isFavorite: isFavorite)
    }
    
    convenience init(_ model: PersistableRecipe) {
        self.init(id: model.id, title: model.title, imageUrl: model.imageUrl, isFavorite: model.isFavorite)
    }
    
    convenience init(_ model: RecipeDetailViewModel) {
        self.init(id: model.id, title: model.title, imageUrl: model.imageUrl, isFavorite: String(model.isFavorite.value))
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(title, forKey: "title")
        coder.encode(imageUrl, forKey: "imageUrl")
        coder.encode(isFavorite, forKey: "isFavorite")
        coder.encode(storedAt, forKey: "storedAt")
    }
    
    func resetStorageTime() {
        self.storedAt = String(NSDate().timeIntervalSince1970)
    }
}

