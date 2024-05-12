//
//  Router.swift
//  Acharya Prashant
//
//  Created by Sonkar, Swapnil on 12/05/24.
//

import Foundation

class Router: RouterType {
    
    func request(route: EndPointType) async throws -> (Data, URLResponse) {
        let request = try buildRequest(from: route)
        return try await URLSession.shared.data(for: request)
    }
}

extension Router {
    
    fileprivate func buildRequest(from route: EndPointType) throws -> URLRequest {
        
        let url = route.baseURL.appending(path: route.path)

        var urlRequest = URLRequest(url: url,
                                    cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                    timeoutInterval: 10.0)
        
        urlRequest.httpMethod = route.httpMethod.rawValue
        switch route.task {
        case .request:
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
        case .requestParameters(let parameterEncoding,
                                let urlParameters,
                                let bodyParameters):
            
            try configureParameters(urlRequest: &urlRequest, parameterEncoding: parameterEncoding, urlParameters: urlParameters, bodyParameters: bodyParameters)
            
        case .requestParametersAndHeaders(let parameterEncoding,
                                          let urlParameters,
                                          let bodyParameters,
                                          let additionalHeaders):
            
            addAdditionalHeaders(additionalHeaders, urlRequest: &urlRequest)
            try configureParameters(urlRequest: &urlRequest, parameterEncoding: parameterEncoding, urlParameters: urlParameters, bodyParameters: bodyParameters)
        }
        
        return urlRequest
    }
    
    fileprivate func configureParameters(urlRequest: inout URLRequest,
                                    parameterEncoding: ParameterEncoding,
                                    urlParameters: Parameters?,
                                    bodyParameters: Parameters?) throws {
        
        try parameterEncoding.encode(urlRequest: &urlRequest, 
                                     urlParameters: urlParameters,
                                     bodyParameters: bodyParameters)
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, urlRequest: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        let _ = headers.map {
            urlRequest.setValue($0.key, forHTTPHeaderField: $0.value)
        }
    }
}
