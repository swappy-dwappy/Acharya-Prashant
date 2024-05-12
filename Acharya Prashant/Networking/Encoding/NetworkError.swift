//
//  NetworkError.swift
//  Acharya Prashant
//
//  Created by Sonkar, Swapnil on 12/05/24.
//

import Foundation

enum NetworkError: LocalizedError {
    case parametersNil
    case encodingFailed
    case missingURL
    
    var errorDescription: String? {
        switch self {
        case .parametersNil:
            return "Parameters were nil."
        case .encodingFailed:
            return "Parameter encoding failed."
        case .missingURL:
            return "URL is nil."
        }
    }
}
