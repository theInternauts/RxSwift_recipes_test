//
//  ImageLoader.swift
//  FavoriteRecipes
//
//  Created by Christopher Wallace on 9/21/21.
//

import UIKit

class ImageLoader {
    // MARK: - Properties/Configuration
    private static var privateManagerForConfiguration: ImageLoader = { return ImageLoader() }()
    
    
    // MARK: - Initialization
    private init() {}
    
    
    // MARK: - Accessors
    class func shared() -> ImageLoader {
        return privateManagerForConfiguration
    }
    
    
    // MARK: - Public
    func loadImage(url: String, then completion: @escaping (Data) -> Void) -> Void {
        guard let url = URL(string: url) else {
            return
        }
        // Background thread
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                
                // Main thread for UI refreshes
                DispatchQueue.main.async {
                    completion(data)
                }
            }
        }
    }
}

