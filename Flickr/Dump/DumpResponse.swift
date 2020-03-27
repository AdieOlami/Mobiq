//
//  DumpResponse.swift
//  Flickr
//
//  Created by Olar's Mac on 3/25/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import Foundation

final class DumpResponse: NSObject {
    
    static func stubbedResponse(_ filename: String) -> Data! {
        @objc class TestClass: NSObject {}
        
        let bundle = Bundle(for: TestClass.self)
        let path = bundle.path(forResource: filename, ofType: "json")
        return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
    }
    
    static func photosResponse() -> String {
        return String(data: stubbedResponse("PhotosJson"), encoding: .utf8)!
    }
}
