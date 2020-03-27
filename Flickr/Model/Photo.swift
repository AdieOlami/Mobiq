//
//  Photo.swift
//  Flickr
//
//  Created by Olar's Mac on 3/25/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import Foundation


struct Photos: Codable {
    let photos: PhotosData
}

struct PhotosData: Codable {
    let page, pages, perpage: Int
    let total: String
    let photo: [Photo]
}

struct Photo: Codable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
}

extension Photo {
    func getImagePath(_ size: String = "m") -> URL?{
        let path = "https://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret)_\(size).jpg"
        return URL(string: path)
    }
}

