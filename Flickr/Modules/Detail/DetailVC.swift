//
//  DetailVC.swift
//  Flickr
//
//  Created by Olar's Mac on 3/25/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    lazy var navLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var nav: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    lazy var backBtn: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(#imageLiteral(resourceName: "arrow"), for: .normal)
        return view
    }()
    
    lazy var selectedImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.contentMode = .scaleAspectFit
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        layout()
        logic()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

}

extension DetailVC {
    private func layout() {
        view.addSubview(selectedImage)
        view.addSubview(nav)
        nav.addSubview(backBtn)
        nav.addSubview(navLabel)
        // Activating all Navigation UI with `activate`
        NSLayoutConstraint.activate([
            nav.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            nav.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            nav.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            nav.heightAnchor.constraint(equalToConstant: 52),
            
            backBtn.centerYAnchor.constraint(equalTo: nav.centerYAnchor),
            backBtn.leadingAnchor.constraint(equalTo: nav.leadingAnchor, constant: 16),
            backBtn.heightAnchor.constraint(equalToConstant: 30),
            backBtn.widthAnchor.constraint(equalToConstant: 30),
            
            navLabel.centerYAnchor.constraint(equalTo: nav.centerYAnchor),
            navLabel.leadingAnchor.constraint(equalTo: backBtn.trailingAnchor, constant: 10),
            navLabel.heightAnchor.constraint(equalToConstant: 30)
            ])
        
        // Seperately constraints this intentionally. Could do both. LOL
        selectedImage.topAnchor.constraint(equalTo: nav.topAnchor, constant: 0).isActive = true
        selectedImage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        selectedImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        selectedImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
    }
    
    private func logic() {
        backBtn.addTarget(self, action: #selector(popVc), for: .touchUpInside)
    }
    
    @objc func popVc() {
        self.navigationController?.popViewController(animated: true)
    }
}
