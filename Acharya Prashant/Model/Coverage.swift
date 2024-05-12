//
//  Coverage.swift
//  Acharya Prashant
//
//  Created by Sonkar, Swapnil on 11/05/24.
//

import Foundation
import UIKit

/*
 Sample response
 
 "id": "coverage-2cc583",
 "title": "Acharya Prashant at Entrepreneur India",
 "language": "english",
 "thumbnail": {
   "id": "img-9a39e8cf-58c9-408b-ad55-6010f7f8e5a9",
   "version": 1,
   "domain": "https://cimg.acharyaprashant.org",
   "basePath": "images/img-9a39e8cf-58c9-408b-ad55-6010f7f8e5a9",
   "key": "image.jpg",
   "qualities": [10, 20, 30, 40],
   "aspectRatio": 1.009
 },
 "mediaType": 0,
 "coverageURL": "https://www.magzter.com/stories/business/Entrepreneur-magazine/ACHARYA-PRASHANT-THE-PRACTICAL-TEACHER",
 "publishedAt": "2024-05-01",
 "publishedBy": "Entrepreneur India",
 "backupDetails": {
   "pdfLink": "https://drive.google.com/file/d/1PPIzQOud1N0H_oAvGnu4NXuX8IoiBCzY/view?usp=sharing",
   "screenshotURL": "https://drive.google.com/file/d/1sl7uH_RdpFHtzV0uemurQjmFmMzQEqi-/view?usp=sharing"
 }
 */

class Coverage: Codable {
    
    var id = ""
    var title = ""
    var language = ""
    var thumbnail: Thumbnail?
    var mediaType = 0
    var coverageURL = ""
    var publishedAt = ""
    var publishedBy = ""
    var backupDetails: BackupDetails?
}

class Thumbnail: Codable {
    
    var id = ""
    var version = 0
    var domain = ""
    var basePath = ""
    var key = ""
    var qualities = [Int]()
    var aspectRatio = 0.0
    
    var image: UIImage? {
        get async {
            switch await NetworkManager().getThumbnail(domain: domain, basePath: basePath, key: key) {
            case .success(let thumbnail):
                return thumbnail
            case .failure(let error):
                print(error.localizedDescription)
                let imageIcon = UIImage(systemName: "photo.circle")?.withTintColor(.red, renderingMode: .alwaysOriginal)
                return imageIcon
            }
        }
    }
}

class BackupDetails: Codable {
    
    var pdfLink = ""
    var screenshotURL = ""
}
