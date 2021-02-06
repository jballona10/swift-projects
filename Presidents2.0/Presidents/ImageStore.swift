//
//  ImageStore.swift
//  Presidents
//
//  Created by Josue Ballona on 11/16/20.
//  Copyright © 2020 Josue Ballona. All rights reserved.
//

import Foundation
import UIKit

class ImageStore {
    
    let imageCache = NSCache<NSString, AnyObject>()
    func downloadImage(with urlString: String, completion: @escaping (_ image: UIImage?) -> Void) {
        
  
        if urlString == "None" {
            completion(UIImage(named: "seal.png"))
        } else if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            completion(cachedImage)
        } else {
        
            weak var weakSelf = self
            
            if let url = URL(string: urlString) {
        
                   let task = URLSession.shared.dataTask(with: url) {
                       (data, response, error) in
                       
                       let httpResponse = response as? HTTPURLResponse
                       if httpResponse!.statusCode != 200 {
                            // perform some error handling
                            // UI updates, like alerts should be directed to the main thread
                            DispatchQueue.main.async {
                                print("HTTP Error: status code \(httpResponse!.statusCode)")
                                completion(UIImage(named: "seal.png"))
                            }
                        } else if (data == nil && error != nil) {
                            // perform some error handling
                            DispatchQueue.main.async {
                                print("No data downloaded for \(urlString)")
                                completion(UIImage(named: "seal.png"))
                            }
                        } else {
                            // download succeeds
                            if let image = UIImage(data: data!) {
                                DispatchQueue.main.async {
                                    weakSelf!.imageCache.setObject(image, forKey: urlString as NSString)
                                    completion(image)
                                }
                            } else {
                                DispatchQueue.main.async {
                                    print("\(urlString) is not a valid image")
                                    completion(UIImage(named: "seal.png"))
                                }
                            }
                        
                        }
                    }
                task.resume()
            }
        }
    }
    
    func clearCache () {
        imageCache.removeAllObjects()
    }
}
