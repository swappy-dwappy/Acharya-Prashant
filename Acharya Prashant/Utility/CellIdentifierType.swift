//
//  CellIdentifierType.swift
//  Acharya Prashant
//
//  Created by Sonkar, Swapnil on 11/05/24.
//

import Foundation
import UIKit

protocol CellIdentifierType {
    
    static var reuseIdentifier: String { get }
}

extension CellIdentifierType {
    
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

extension UICollectionViewCell: CellIdentifierType {}
