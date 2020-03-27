//
//  HomeVC.swift
//  Flickr
//
//  Created by Olar's Mac on 3/25/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import UIKit
import Kingfisher

class HomeVC: UIViewController {
    
    fileprivate var autoCompleteTableView: UITableView?
    var autoCompletePlacesData = [String]()
    var selectedPlace: ((String, IndexPath) -> Void)?
    var autoCompleteTextFont = UIFont.systemFont(ofSize: 12)
    var autoCompleteTextColor = UIColor.black
    var autoCompleteCellHeight: CGFloat = 44.0
    var autoCompleteSeparatorInset = UIEdgeInsets.zero
    var hidesWhenSelected = true
    
    var hidesWhenEmpty: Bool? {
        didSet {
            DispatchQueue.main.async {
                self.autoCompleteTableView?.isHidden = self.hidesWhenEmpty!
            }
        }
    }
    var autoCompleteTableHeight: CGFloat? {
        didSet {
            redrawTable()
        }
    }
    
    // this is the x margin for table view from textfield
    var autoCompleteTableMargin = CGFloat()
    
    fileprivate func redrawTable() {
        if let autoCompleteTableView = autoCompleteTableView, let autoCompleteTableHeight = autoCompleteTableHeight {
            var newFrame = autoCompleteTableView.frame
            newFrame.size.height = autoCompleteTableHeight
            autoCompleteTableView.frame = newFrame
        }
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = autoCompleteCellHeight
        tableView.isHidden = hidesWhenEmpty ?? true
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.layer.borderWidth = 0.5
        return tableView
    }()
    
    private var presenter: HomeContract.Presenter!
    var photoArray: [Photo] = [Photo]()
        
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var loadingLbl: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    fileprivate var searchBar = UISearchBar()
    fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    fileprivate var numberOfCellInArow: CGFloat = 2.0
    fileprivate var cellPadding:CGFloat = 10.0
    fileprivate var isLoading = false
    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
    
    func navigationBarSetUp() {
        searchBar.placeholder = "Search Images"
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        let optionBtn = UIBarButtonItem(image: UIImage(named: "history"), style: .plain, target: self, action: #selector(historyTapped))
        self.navigationItem.rightBarButtonItem = optionBtn
    }

    @objc func historyTapped() {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.autoCompleteTableView?.isHidden = !(self.autoCompleteTableView?.isHidden ?? false)
        })
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = HomePresenter(view: self, source: NetworkAdapter.instance)
        presenter.start()
        self.collectionView.dataSource = self

        collectionView.delegate = self
        self.navigationBarSetUp()
        setupAutocompleteTable(view)
        hideKeyboardWhenTappedAround()
    }
    
    
    deinit {
        presenter.stop()
    }
    
    private func fetchImages() {
        presenter.getImages(text: searchBar.text ?? "")
        guard let text = searchBar.text else {return}
        Storage.instance.saveSearchValues(text)
    }
}

//MARK: - SearchBar Delegate
extension HomeVC: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        //Reset old data first befor new search Results
        presenter.resetValues()
        photoArray.removeAll()
        guard let text = searchBar.text?.components(separatedBy: .whitespaces).joined(),
            text.count != 0  else {
                loadingLbl.text = "Please type keyword to search result."
                return
        }
        //Requesting new keyword
        
        self.fetchImages()
        loadingLbl.text = "Searching Images..."
    }
}

//MARK: - Collection View Delegate
extension HomeVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if cell is PhotoCell {
            DispatchQueue.main.async {
                if let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell {
                    cell.cellImage.kf.indicatorType = .activity
                    cell.cellImage.kf.setImage(with: self.photoArray[indexPath.row].getImagePath())
                }
            }

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = DetailVC()
        controller.navLabel.text = self.photoArray[indexPath.row].title
        controller.selectedImage.kf.indicatorType = .activity
        controller.selectedImage.kf.setImage(with: self.photoArray[indexPath.row].getImagePath())
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - UICollectionViewDataSource
extension HomeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        guard self.photoArray.count != 0 else {
            return cell
        }
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.bounds.width;
        let itemWidth = collectionWidth / numberOfCellInArow - cellPadding;
        
        return CGSize(width: itemWidth, height: itemWidth);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellPadding
    }
}

//MARK: - Scrollview Delegate
extension HomeVC: UIScrollViewDelegate {
    //MARK :- Getting user scroll down event here
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView{
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= (scrollView.contentSize.height)){
                //locading new data
                if(!isLoading){
                    self.addLoader()
                    self.fetchImages()
                    isLoading = true
                }
            }
        }
    }
    //MARK: Loader at bottom
    fileprivate func addLoader() {
        self.activityIndicator.isHidden = false
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            self.collectionViewBottomConstraint.constant = 40
        }, completion: nil)
    }

    fileprivate func removeLoader() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            self.activityIndicator.isHidden = true
            self.collectionViewBottomConstraint.constant = 0
        }, completion: nil)
    }
    
    fileprivate func loader() {
        self.isLoading = false
        self.removeLoader()
        self.loadingLbl.text = ""
    }
}

// MARK: History Tableview Delegate & Datasource
extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Storage.instance.getSearchValues().count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "autocompleteCellIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        cell?.textLabel?.font = autoCompleteTextFont
        cell?.textLabel?.textColor = autoCompleteTextColor
        cell?.textLabel?.text = Storage.instance.getSearchValues()[indexPath.row]
        cell?.textLabel?.numberOfLines = 0
        cell?.contentView.gestureRecognizers = nil
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadData()
        searchBar.text = Storage.instance.getSearchValues()[indexPath.row]
        fetchImages()
        DispatchQueue.main.async(execute: { () -> Void in
            tableView.isHidden = self.hidesWhenSelected
        })
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = autoCompleteSeparatorInset
        }
        if cell.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins)) {
            cell.preservesSuperviewLayoutMargins = false
        }
        if cell.responds(to: #selector(setter: UIView.layoutMargins)) {
            cell.layoutMargins = autoCompleteSeparatorInset
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return autoCompleteCellHeight
    }
    
    fileprivate func setupAutocompleteTable(_ view: UIView) {
        autoCompleteTableMargin = 10.0
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            tableView.heightAnchor.constraint(equalToConstant: 180),
        ])
        autoCompleteTableView = tableView
        autoCompleteTableHeight = 180.0
        
    }
    
}

// MARK: Views
extension HomeVC: HomeContract.View {
    // This passes the images from the presenter to determine the view
    func showImages(photo: [Photo]) {
        self.photoArray.removeAll()
        DispatchQueue.main.async {
            self.photoArray.append(contentsOf: photo)
            self.loader()
            self.collectionView.reloadData()
        }
        
    }
    
    func showError(message: String) {
        loader()
        let alert = UIAlertController(title: "Error Occured", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
