//
//  HomeViewController.swift
//  Donategram
//
//  Created by Yevhenii Kovalenko on 26.05.2020.
//  Copyright © 2020 Yevhenii Kovalenko. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var postValues: [PostModel] = []
    static var userToken = ""

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTableValues()
    }
    
    fileprivate func loadTableValues() {
        PostApiManager.getAllPosts { (responce) in
            switch responce.result {
            case .failure(let error):
                print("(Debug) Error all post loader: \(String(describing: error.errorDescription))")
            case .success:
                if responce.response?.statusCode == 200 {
                    let data = responce.value as! [Any]
                    for value in data {
                        let dict = value as! [String: Any]
                        self.postValues.append(PostModel(name: dict["name"] as? String ?? "",
                                                         description: dict["description"] as? String ?? "",
                                                         imgpath: dict["imgPath"] as? String ?? "",
                                                         applicationUserId: dict["applicationUserId"] as? String ?? ""))
                    }
                    self.tableView.reloadData()
                    return
                }
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        postValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
        let values = postValues[indexPath.row]
        cell.cellTitle.text = values.name
        cell.cellDescr.text = values.description
        if values.imgpath != "" {
            cell.cellImage.imageFromURL(urlString: "https://charityappppp.azurewebsites.net" + values.imgpath)
        } else {
            cell.cellImage.image = UIImage(systemName: "timelapse")
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 380
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension UIImageView {
    public func imageFromURL(urlString: String) {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        activityIndicator.startAnimating()
        if self.image == nil{
            self.addSubview(activityIndicator)
        }

        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in

            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                activityIndicator.removeFromSuperview()
                self.image = image
            })

        }).resume()
    }
}
