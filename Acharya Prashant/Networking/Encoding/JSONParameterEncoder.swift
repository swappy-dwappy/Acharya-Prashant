//
//  JSONParameterEncoder.swift
//  Acharya Prashant
//
//  Created by Sonkar, Swapnil on 12/05/24.
//

import Foundation

struct JSONParameterEncoder: ParameterEncoderType {
    
    func encode(urlRequest: inout URLRequest, parameters: Parameters) throws {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonData
        } catch {
            throw NetworkError.encodingFailed
        }
    }
}
