//
//  RouterType.swift
//  Acharya Prashant
//
//  Created by Sonkar, Swapnil on 12/05/24.
//

import Foundation

protocol RouterType: AnyObject {
    
    func request(route: EndPointType) async throws -> (Data, URLResponse)
}
