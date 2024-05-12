//
//  ImageCVC.swift
//  Acharya Prashant
//
//  Created by Sonkar, Swapnil on 11/05/24.
//

import UIKit

class ImageCVC: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var representedIdentifier: String = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.darkGray.cgColor
    }
}

