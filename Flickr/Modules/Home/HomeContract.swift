//
//  HomeContract.swift
//  Flickr
//
//  Created by Olar's Mac on 3/25/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import Foundation

struct HomeContract {
    typealias View = _HomeView
    typealias Presenter = _HomePresenter
}

protocol _HomeView: BaseView {
    func showImages(photo: [Photo])
    func showError(message: String)
}

protocol _HomePresenter: BasePresenter {
    func getImages(text: String)
    func resetValues()
}
