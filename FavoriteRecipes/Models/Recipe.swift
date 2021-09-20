//
//  Recipe.swift
//  FavoriteRecipes
//
//  Created by Christopher Wallace on 9/20/21.
//


struct Recipe: Codable, Hashable {
    var id: String
    var type: Type.RawValue
    var attributes: Attributes
    var isFavorite: Bool? = false
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.id == rhs.id
    }
}

enum Type: String, Codable {
    case video
}

struct Attributes: Codable {
    var title: String
    var thumbnailSquareUrl: String

    enum CodingKeys: String, CodingKey {
        case title
        case thumbnailSquareUrl = "thumbnail-square-url"
    }
}

