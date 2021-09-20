//
//  RxHTTPService.swift
//  FavoriteRecipes
//
//  Created by Christopher Wallace on 9/20/21.
//

import UIKit
import RxSwift
import RxCocoa


class RxHTTPService: RecipeServiceProtocol {
    // MARK: - Properties/Configuration
    private static var privateManagerForConfiguration: RecipeServiceProtocol = { return RxHTTPService() }()
    
    private let baseURL = URL(string: DataSourcesUrls.recipes)!
    private let defaultSession = URLSession(configuration: .default)
    private var task: URLSessionDataTask? = nil
    
    
    // MARK: - Initialization
    private init() {}
    
    
    // MARK: - Accessors
    class func shared() -> RecipeServiceProtocol {
        return privateManagerForConfiguration
    }
    
    internal func fetchRx<T: Codable>() -> Observable<T> {
        return Observable<T>.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create {} }
            
            self.task = self.defaultSession.dataTask(with: self.baseURL) { [weak self] data, response, error in
                // Handle Errors
                guard self != nil else {
                    observer.onError(APIErrors.deallocatedService(error))
                    return
                }
                guard let data = data else {
                    observer.onError(APIErrors.responseDataNotFound(error))
                    return
                }
                guard error == nil else {
                    observer.onError(APIErrors.fetchError(error))
                    return
                }
                
                // Process Request
                do {
                    let dataSet: BigData = try JSONDecoder().decode(BigData.self, from: data)
                    observer.onNext(dataSet.data as! T)
                } catch(let error) {
                    observer.onError(APIErrors.unprocessableData(error))
                }
                observer.onCompleted()
            }
            self.task?.resume()
            
            return Disposables.create {
                self.task?.cancel()
            }
        }
    }
}
