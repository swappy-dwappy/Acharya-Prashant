//
//  NetworkManager.swift
//  Acharya Prashant
//
//  Created by Sonkar, Swapnil on 12/05/24.
//

import Foundation
import UIKit

enum NetworkResponse: String, Error {
    case success
    case authenticationError
    case badRequest
    case outdated
    case failed
    case noData
    case unableToDecode
}

struct NetworkManager {

    static let environment: NetworkEnvironment = .production
    
    private let cache = NSCache<NSString, UIImage>()
    
    func getMediaCoverage(limit: Int) async -> Result<[Coverage], Error> {
        do {
            let (data, response) = try await Router().request(route: MediaCoverageApi.coverage(limit: limit))
            if let response = response as? HTTPURLResponse {
                switch handleNetworkResponse(response) {
                case .success(_):
                    let coverages = try JSONDecoder().decode([Coverage].self, from: data)
                    return .success(coverages)
                case .failure(let error):
                    return .failure(error)
                }
            } else {
                return .failure(NetworkResponse.noData)
            }
        } catch {
            return .failure(error)
        }
    }
    
    func getThumbnail(domain: String, basePath: String, key: String) async -> Result<UIImage, Error> {
        
        let cacheKey = basePath + key
        if let image = cache.object(forKey: cacheKey as NSString) {
            return .success(image)
        } else {
            do {
                let (data, response) = try await Router().request(route: ThumbnailApi.thumbnail(domain: domain, basePath: basePath, key: key))
                if let response = response as? HTTPURLResponse {
                    switch handleNetworkResponse(response) {
                    case .success(_):
                        if let image = UIImage(data: data) {
                            cache.setObject(image, forKey: cacheKey as NSString)
                            return .success(image)
                        } else {
                            return .failure(NetworkResponse.noData)
                        }
                    case .failure(let error):
                        return .failure(error)
                    }
                } else {
                    return .failure(NetworkResponse.noData)
                }
            } catch {
                return .failure(error)
            }
        }
    }
}

extension NetworkManager {
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String, Error> {
        switch response.statusCode {
        case 200...299: return .success(NetworkResponse.success.rawValue)
        case 401...500: return .failure(NetworkResponse.authenticationError)
        case 501...599: return .failure(NetworkResponse.badRequest)
        case 600: return .failure(NetworkResponse.outdated)
        default: return .failure(NetworkResponse.failed)
        }
    }
}
