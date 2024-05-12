//
//  MediaCoverageEndPoint.swift
//  Acharya Prashant
//
//  Created by Sonkar, Swapnil on 12/05/24.
//

import Foundation

enum NetworkEnvironment {
    case qa
    case production
    case staging
}

enum MediaCoverageApi {
    case coverage(limit: Int)
}

extension MediaCoverageApi: EndPointType {

    var environmentBaseURL: String {
        switch NetworkManager.environment {
        case .production: return "https://acharyaprashant.org/api/v2"
        case .qa: return "https://acharyaprashant.org/api/v2"
        case .staging: return "https://acharyaprashant.org/api/v2"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else {
            fatalError("Base URL could not be configured.")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .coverage(_):
            return "content/misc/media-coverages"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .coverage(_):
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .coverage(let limit):
            return .requestParameters(parameterEncoding: .urlEncoding,
                                      urlParameters: ["limit": limit],
                                      bodyParameters: nil)
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .coverage(_):
            return nil
        }
    }
}
