//
//  HTTPTask.swift
//  Acharya Prashant
//
//  Created by Sonkar, Swapnil on 12/05/24.
//

import Foundation

typealias HTTPHeaders = [String: String]

enum HTTPTask {
    
    case request
    
    case requestParameters(parameterEncoding: ParameterEncoding,
                           urlParameters: Parameters?,
                           bodyParameters: Parameters?)
    
    case requestParametersAndHeaders(parameterEncoding: ParameterEncoding,
                                     urlParameters: Parameters?,
                                     bodyParameters: Parameters?,
                                     additionalHeaders: HTTPHeaders?)
    }
