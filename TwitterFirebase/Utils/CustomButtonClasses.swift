//
//  CustomImageView.swift
//  TwitterFirebase
//
//  Created by Abhishesh Pradhan on 26/4/18.
//  Copyright © 2018 Abhishesh Pradhan. All rights reserved.
//

import UIKit

var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
    
    var lastURLUsedToLoadImage: String?
    
    func loadImage(urlString: String){
        lastURLUsedToLoadImage = urlString
        
        self.image = nil
        
        if let cachedImage = imageCache[urlString] {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("Failed to open the image url", err)
            }
            
            if url.absoluteString != self.lastURLUsedToLoadImage{
                return
            }
            
            guard let imageData = data else { return }
            let photoImage = UIImage(data: imageData)
            
            imageCache[url.absoluteString] = photoImage
            
            DispatchQueue.main.async {
                self.image = photoImage
            }
            }.resume()
    }
}

class CustomImageButton: UIButton {
    
    var lastURLUsedToLoadImage: String?
    
    func loadImage(urlString: String){
        lastURLUsedToLoadImage = urlString
        
        if let cachedImage = imageCache[urlString] {
            self.setImage(cachedImage, for: .normal)
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("Failed to open the image url", err)
            }
            
            if url.absoluteString != self.lastURLUsedToLoadImage{
                return
            }
            
            guard let imageData = data else { return }
            let photoImage = UIImage(data: imageData)
            
            imageCache[url.absoluteString] = photoImage
            
            DispatchQueue.main.async {
                self.setImage(photoImage, for: .normal)
            }
            }.resume()
    }
}

class CustomNavBarButton: UIBarButtonItem {
    
    var lastURLUsedToLoadImage: String?
    
    func loadImage(urlString: String){
        lastURLUsedToLoadImage = urlString
        
        if let cachedImage = imageCache[urlString] {
            self.setBackgroundImage(cachedImage, for: .normal, barMetrics: .default)
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("Failed to open the image url", err)
            }
            
            if url.absoluteString != self.lastURLUsedToLoadImage{
                return
            }
            
            guard let imageData = data else { return }
            let photoImage = UIImage(data: imageData)
            
            imageCache[url.absoluteString] = photoImage
            
            DispatchQueue.main.async {
                self.setBackgroundImage(photoImage, for: .normal, barMetrics: .default)
            }
            }.resume()
    }
}
