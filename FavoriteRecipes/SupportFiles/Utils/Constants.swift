//
//  Constants.swift
//  FavoriteRecipes
//
//  Created by Christopher Wallace on 9/20/21.
//

import UIKit


// MARK: - Standardized Error Messages
enum APIErrors: Error {
    case fetchError(_ error: Error?)
    case responseDataNotFound(_ error: Error?)
    case unprocessableData(_ error: Error?)
    case queryTimeout(_ error: Error?)
    case validationFailed(_ error: Error?)
    case invalidRequestUrl(_ error: Error?)
    case deallocatedService(_ error: Error?)
    case persistenceSaveError(_ error: Error?)
    case persistenceRetrievalError(_ error: Error?)
    
    var extendedMessage: String {
        get {
            switch self {
            case .fetchError(let error): return "Unknown fetch error: \(String(describing: error?.localizedDescription))"
            case .responseDataNotFound(let error): return "no data returned from fetch request: \(String(describing: error?.localizedDescription))"
            case .unprocessableData(let error): return "Unable to decode response data: \(String(describing: error?.localizedDescription))"
            case .queryTimeout(let error): return "\(String(describing: error?.localizedDescription))"
            case .validationFailed(let error): return "\(String(describing: error?.localizedDescription))"
            case .invalidRequestUrl(let error): return "\(String(describing: error?.localizedDescription))"
            case .deallocatedService(let error): return "RxHTTPService was deallocated: \(String(describing: error?.localizedDescription))"
            case .persistenceSaveError(let error): return "Unable to save to the persistence layer: \(String(describing: error?.localizedDescription))"
            case .persistenceRetrievalError(let error): return "Unable to read from the persistence layer: \(String(describing: error?.localizedDescription))"
            }
        }
    }
}


enum ApplicationText: String {
    case recipes = "レシピ"
    case favorites = "お気に入り"
    case start = "スタット"
}


enum IconLabels: String {
    case recipesInactive = "house"
    case recipesActive = "house.fill"
    case favoritesInactive = "heart"
    case favoritesActive = "heart.fill"
}


enum ImageSet {
    static let placeholderImage = UIImage(systemName: "building.2.crop.circle.fill")!
    static let favoritesTRUE = UIImage(systemName: "heart.fill")!
    static let favoritesFALSE = UIImage(systemName: "heart")!
}


enum DataSourcesUrls {
    static let recipes = "https://s3-ap-northeast-1.amazonaws.com/data.kurashiru.com/videos_sample.json"
}


enum Colors {
    static let gold = UIColor(red: 212/255, green: 180/255, blue: 94/255, alpha: 1)
    static let pink = UIColor(red: 231/255, green: 110/255, blue: 80/255, alpha: 1)
    static let gray = UIColor(red: 98/255, green: 95/255, blue: 90/255, alpha: 1)
}

// gold
// rgb(212 180 94)
// #d4b45e
// hsl(44deg 58% 60%)
// UIColor(red: 212/255, green: 180/255, blue: 94/255, alpha: 1)


// pink
// rgb(231 110 80)
// #e76e50
// hsl(12deg 76% 61%)
// UIColor(red: 231/255, green: 110/255, blue: 80/255, alpha: 1)

// gray
// rgb(98 95 90)
// #625f5b
// hsl(37deg 4% 37%)
// UIColor(red: 98/255, green: 95/255, blue: 90/255, alpha: 1)


