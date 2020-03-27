//
//  Api.swift
//  Flickr
//
//  Created by Olar's Mac on 3/25/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import UIKit
import Moya

enum Api {
    case getImages(pageCount: String, text: String)
}

extension Api: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.flickr.com/services/rest/")!
    }
    
    var path: String {
        switch self {
        case .getImages: return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getImages: return .get
        }
    }
    
    // Leave for Unit Test
    var sampleData: Data {
        switch self {
        case .getImages: return DumpResponse.stubbedResponse("PhotosJson")
        }
    }
    
    var task: Task {
        let params = Params.build()
        switch self {
        case .getImages(let data): return .requestParameters(parameters: ["method": params["method"] ?? "", "api_key": params["api_key"] ?? "", "format": params["format"] ?? "", "nojsoncallback": params["nojsoncallback"] ?? "", "safe_search": data.pageCount, "text": data.text, "per_page": Const.perPageCount], encoding: URLEncoding.default)        }
    }
    
    public var headers: [String: String]? {
        return [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
    }
}
