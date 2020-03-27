//
//  NetworkAdapter.swift
//  Flickr
//
//  Created by Olar's Mac on 3/25/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import Foundation
import Moya

class NetworkAdapter: DataSource {

    private var provider = MoyaProvider<Api>(manager: ApiClient.session, plugins: [NetworkLoggerPlugin(verbose: true)], trackInflights: true)
    
//    private let provider: MoyaProvider<MultiTarget>
//
//    init(provider: MoyaProvider<MultiTarget> = MoyaProvider<MultiTarget>()) {
//        self.provider = provider
//    }
    public static let instance = NetworkAdapter()
    
    func getImages(pageCount: String, text: String, completionHandler: @escaping (Result<Photos, Error>) -> ()) {
        provider.request(.getImages(pageCount: pageCount, text: text), objectModel: Photos.self, success: { (resp) in
            completionHandler(.success(resp))
            print(resp)
        }) { (err) in
            completionHandler(.failure(err))
            print(err)
        }
    }
    
}
