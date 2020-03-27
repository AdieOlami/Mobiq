//
//  HomePresenter.swift
//  Flickr
//
//  Created by Olar's Mac on 3/25/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import Foundation

class HomePresenter: HomeContract.Presenter {
    
    private var view: HomeContract.View?
    private var source: DataSource!
    
    fileprivate var pageCount = 0
    fileprivate var photos: [Photo] = [Photo]()
    
    init(view: HomeContract.View, source: DataSource) {
        self.source = source
        self.view = view
    }

    func getImages(text: String) {
        pageCount += 1
        source.getImages(pageCount: pageCount.description, text: text) {[weak self] (result) in
            switch result {
                
            case .success(let suc):
                guard let self = self else  {return}
                self.photos.append(contentsOf: suc.photos.photo)
                self.view?.showImages(photo: self.photos)
            case .failure(let err):
                guard let self = self else {return}
                self.view?.showError(message: err.localizedDescription)
            }
        }
    }
    
    func resetValues() {
        pageCount = 0
        photos.removeAll()
    }
    
    func start() {
        
    }
    
    func stop() {
        
    }
}
