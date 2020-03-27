//
//  Params.swift
//  Flickr
//
//  Created by Olar's Mac on 3/25/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import Foundation

final class Params {
    
    static func build() -> [String: String] {
        let params = ["method" : "flickr.photos.search",
                      "api_key" : Const.flickerApiKey,
                      "nojsoncallback" : "1",
                      "format": "json"]
        return params
    }
}
