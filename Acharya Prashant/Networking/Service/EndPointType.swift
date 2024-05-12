//
//  EndPointType.swift
//  Acharya Prashant
//
//  Created by Sonkar, Swapnil on 12/05/24.
//

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}
