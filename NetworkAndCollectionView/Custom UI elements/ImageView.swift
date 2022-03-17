//
//  ImageView.swift
//  NetworkAndCollectionView
//
//  Created by Михаил Малышев on 16.03.2022.
//

import UIKit

import CoreData

class ImageView: UIImageView {
    
    private let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fetchImage(from url: String) {
        guard let imageURL = URL(string: url) else {
            return
        }
        
        if let cachedImage = getCachedImage(url: imageURL) {
            image = cachedImage
            return
        }
        
        ImageDownloadManager.shared.getImage(from: imageURL) { (data, response) in
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
            
            self.saveDataToCache(with: data, and: response)
            self.save(data: data)
        }
        
    }
    
    private func getCachedImage(url: URL) -> UIImage? {
        let urlRequest = URLRequest(url: url)
        if let cachedResponse = URLCache.shared.cachedResponse(for: urlRequest) {
            return UIImage(data: cachedResponse.data)
        }
        return nil
    }
    
    private func saveDataToCache(with data: Data, and response: URLResponse) {
        guard let urlResponse = response.url else { return }
        let cachedResponse = CachedURLResponse(response: response, data: data)
        let urlRequest = URLRequest(url: urlResponse)
        URLCache.shared.storeCachedResponse(cachedResponse, for: urlRequest)
    }
    
    private func save(data: Data) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "ImageData", in: viewContext) else { return }
        guard let imageData = NSManagedObject(entity: entityDescription, insertInto: viewContext) as? ImageData else { return }
        imageData.data = data
        
        do {
            try viewContext.save()
            print(imageData)
        } catch let error {
            print(error)
        }
    }
}
