//
//  DonateViewController.swift
//  Donategram
//
//  Created by Yevhenii Kovalenko on 26.05.2020.
//  Copyright © 2020 Yevhenii Kovalenko. All rights reserved.
//

import UIKit

class DonateViewController: UIViewController {
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var collectionView: UICollectionView!
    
    var tableValues: [DonateModel] = []
    var searchedValues: [DonateModel] = []
    
    var isSearchBarEmpty: Bool {
      return searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAllValues()
        searchView.layer.cornerRadius = 15
        searchView.layer.masksToBounds = true
        initSearch()
    }
    
    func initSearch() {
    //    searchController.searchResultsUpdater = self
    //    searchController.obscuresBackgroundDuringPresentation = false
       // viewForSearchBar.addSubview(searchController.searchBar)
        searchBar.delegate = self
        searchBar.placeholder = "Search..."
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        
        //     let scb = searchController.searchBar
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = .white
        }
    }
    
    fileprivate func loadAllValues() {
        DonateApiManager.getAllDonates { (response) in
            switch response.result {
            case .failure(let error):
                print("(Debug) Error all post loader: \(String(describing: error.errorDescription))")
            case .success:
                if response.response?.statusCode == 200 {
                    let data = response.value as! [Any]
                    for value in data {
                        let dict = value as! [String: Any]
                        self.tableValues.append(DonateModel(id: dict["id"] as? Int ?? 0,
                                                            name:  dict["name"] as? String ?? "",
                                                            info: dict["info"] as? String ?? "",
                                                            imgPath: dict["imgPath"] as? String ?? ""))
                        print("--- imgLink: \(dict["imgPath"] as? String ?? "")")
                    }
                    self.collectionView.reloadData()
                    return
                }
            }
        }
    }
    
    func removeValues() {
        searchedValues = tableValues
        collectionView.reloadData()
    }
    
    @objc func donateDidTap(_ sender: UIButton) {
        PaymentViewController.paymantData.removeAll()
        if isFiltering {
            PaymentViewController.paymantData.append(searchedValues[sender.tag])
            self.performSegue(withIdentifier: "goToDonate", sender: nil)
        } else {
            PaymentViewController.paymantData.append(tableValues[sender.tag])
            self.performSegue(withIdentifier: "goToDonate", sender: nil)
        }
    }
}

extension DonateViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
    
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if isFiltering {
                return searchedValues.count
            } else {
                return tableValues.count
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "donateCollectionCell", for: indexPath) as! DonateCollectionViewCell
            
            cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.cornerRadius = 10
            cell.contentView.layer.masksToBounds = true
            cell.donateButton.layer.cornerRadius = 10
            cell.donateButton.layer.masksToBounds = true
            cell.donateButton.addTarget(self, action: #selector(donateDidTap(_:)), for: .touchUpInside)
            cell.donateButton.tag = indexPath.row
            
            if !isFiltering {
                if indexPath.item < tableValues.count {
                    cell.cellTitle.text = tableValues[indexPath.item].name
                    cell.cellInfo.text = tableValues[indexPath.item].info
                    if tableValues[indexPath.item].imgPath != "" {
                    cell.cellImage.imageFromURL(urlString: "https://charityappppp.azurewebsites.net" + tableValues[indexPath.item].imgPath)
                    } else {
                        cell.cellImage.image = UIImage(systemName: "timelapse")
                    }
                }
            } else {
                if indexPath.item < tableValues.count {
                    cell.cellTitle.text = searchedValues[indexPath.item].name
                    cell.cellInfo.text = searchedValues[indexPath.item].info
                    if searchedValues[indexPath.item].imgPath != "" {
                    cell.cellImage.imageFromURL(urlString: "https://charityappppp.azurewebsites.net" + searchedValues[indexPath.item].imgPath)
                    } else {
                        cell.cellImage.image = UIImage(systemName: "timelapse")
                    }
                }
            }
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            print("selectedItem: \(indexPath.item)")
        }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width/2 - 10, height: UIScreen.main.bounds.width/1.8 - 10)
    }
}

extension DonateViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText (searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        print(searchText)
      searchedValues = tableValues.filter {
        $0.name.contains(searchText)
      }
      collectionView.reloadData()
    }
}

extension DonateViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.endEditing(true)
        removeValues()
        searchBar.showsCancelButton = false
        print("Back button")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchBar.text!)
    }
}
