//
//  MainCollectionViewCell.swift
//  NetworkAndCollectionView
//
//  Created by Михаил Малышев on 15.03.2022.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: ImageView!
    
    override func layoutSubviews() {
        photoImageView.layer.cornerRadius = 10
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    
    func configure(with image: Image) {
        photoImageView.fetchImage(from: image.urls.small)
    }
}
