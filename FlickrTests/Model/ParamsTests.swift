//
//  ParamsTests.swift
//  FlickrTests
//
//  Created by Olar's Mac on 3/25/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import XCTest
@testable import Flickr

class ParamsTests: XCTestCase {

    func testBuild() {
        let parameters = Params.build()
        XCTAssertEqual(parameters["method"], "flickr.photos.search")
        XCTAssertEqual(parameters["api_key"], "75f49785083cf8953a3febfae04469da")
        XCTAssertEqual(parameters["nojsoncallback"], "1")
        XCTAssertEqual(parameters["format"], "json")
    }

}
