//
//  UrlTests.swift
//  FlickrTests
//
//  Created by Olar's Mac on 3/25/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import XCTest
import Moya
@testable import Flickr

class UrlTests: XCTestCase {
//    var newtworkAdapter: NetworkAdapter!
    var provider: MoyaProvider<Api>!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
//        newtworkAdapter = NetworkAdapter(provider: MoyaProvider<MultiTarget>(stubClosure: MoyaProvider.immediatelyStub))
        
        // A mock provider with a mocking `endpointClosure` that stub immediately
        provider = MoyaProvider<Api>(endpointClosure: customEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func customEndpointClosure(_ target: Api) -> Endpoint {
        return Endpoint(url: URL(target: target).absoluteString,
                        sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                        method: target.method,
                        task: target.task,
                        httpHeaderFields: target.headers)
    }

    func testUrl() {

        provider.request(.getImages(pageCount: "2", text: "food"), objectModel: Photos.self, success: { (response) in
            XCTAssert(response.photos.photo.count == 50, "Photo Count")
            XCTAssert(response.photos.pages == 3409, "Photo Pages")
            XCTAssert(response.photos.perpage == 50, "Photo Per Page")
            XCTAssertEqual(response.photos.photo.first?.getImagePath(), URL(string: "https://farm5.static.flickr.com/4453/37111227204_eef48af510_m.jpg")!, "Image URL")
            XCTAssertTrue(response.photos.photo.count > 0, "Response Photo Count")
            
            guard let photo = response.photos.photo.first else {
                XCTFail("photo is nil.")
                return
            }
            
            XCTAssertEqual(photo.farm, 5)
            XCTAssertEqual(photo.server, "4453")
            XCTAssertEqual(photo.id, "37111227204")
            XCTAssertEqual(photo.secret, "eef48af510")
            
        }) { (error) in
            XCTAssert(false, "not in here")
        }
    }

}
