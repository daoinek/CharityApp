//
//  PostTableViewCell.swift
//  Donategram
//
//  Created by Yevhenii Kovalenko on 26.05.2020.
//  Copyright © 2020 Yevhenii Kovalenko. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellDescr: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.layer.cornerRadius = 10
        cellView.layer.borderColor = UIColor.lightGray.cgColor
        cellView.layer.borderWidth = 1
        cellView.layer.masksToBounds = true
        cellImage.layer.cornerRadius = 10
        cellImage.layer.borderColor = UIColor.lightGray.cgColor
        cellImage.layer.borderWidth = 1
        cellImage.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
