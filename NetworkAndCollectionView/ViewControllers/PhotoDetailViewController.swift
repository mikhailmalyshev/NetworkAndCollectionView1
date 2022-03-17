//
//  PhotoDetailViewController.swift
//  NetworkAndCollectionView
//
//  Created by Михаил Малышев on 16.03.2022.
//

import UIKit

class PhotoDetailViewController: UIViewController {

    var image: Image?
    var imageData: ImageData?
    
    @IBOutlet weak var photoView: ImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = image {
            photoView.fetchImage(from: image.urls.regular)
        }
        
        if let imageData = imageData?.data {
            photoView.image = UIImage(data: imageData)
        }
    }
}
