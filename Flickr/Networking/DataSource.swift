//
//  DataSource.swift
//  Flickr
//
//  Created by Olar's Mac on 3/25/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import Foundation


protocol DataSource {
    func getImages(pageCount: String, text: String, completionHandler: @escaping (Result<Photos, Error>) -> ())
}
