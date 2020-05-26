//
//  UIView+BlurLoader.swift
//  Donategram
//
//  Created by Yevhenii Kovalenko on 26.05.2020.
//  Copyright © 2020 Yevhenii Kovalenko. All rights reserved.
//

import UIKit

extension UIView {
    func showBlurLoader() {
           let blurLoader = BlurLoader(frame: frame)
           self.addSubview(blurLoader)
           blurLoader.isUserInteractionEnabled = true
           blurLoader.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
           blurLoader.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
           blurLoader.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
           blurLoader.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
           blurLoader.translatesAutoresizingMaskIntoConstraints = false
       }
       
       func removeBlurLoader() {
           if let blurLoader = subviews.first(where: { $0 is BlurLoader }) {
               blurLoader.isUserInteractionEnabled = false
               blurLoader.removeFromSuperview()
           }
       }
    
}
