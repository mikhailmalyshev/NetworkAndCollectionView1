//
//  PhotoCollectionViewController.swift
//  NetworkAndCollectionView
//
//  Created by Михаил Малышев on 15.03.2022.
//

import UIKit
import CoreData

class PhotoCollectionViewController: UICollectionViewController {
    
    private let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var images = [Image]()
    private var fetchedImagesFromCoreData = [ImageData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionViewLayout()
        setupRandomImages()
        
        if images.count == 0 {
            fetchImageFromCoreData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if images.count == 0 {
            return fetchedImagesFromCoreData.count
        } else {
            return images.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! MainCollectionViewCell
        cell.photoImageView.image = nil
        if images.count == 0 {
            if let imageData = fetchedImagesFromCoreData[indexPath.item].data {
                cell.photoImageView.image = UIImage(data: imageData)
            }
        } else {
            cell.configure(with: images[indexPath.item])
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == images.count - 1 {
            NetworkManager.shared.fetchRandomImages { (randomSingleImages) in
                guard let fetchedImages = randomSingleImages else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.images += fetchedImages
                    print(self.images.count)
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first else { return }
        let detailVC = segue.destination as! PhotoDetailViewController
        
        if !images.isEmpty {
            let image = images[indexPath.row]
            detailVC.image = image
        } else {
            let imageData = fetchedImagesFromCoreData[indexPath.row]
            detailVC.imageData = imageData
        }
    }
    
    private func setupRandomImages() {
        NetworkManager.shared.fetchRandomImages { (randomSingleImages) in
            guard let fetchedImages = randomSingleImages else { return }
            DispatchQueue.main.async {
                self.images = fetchedImages
                self.collectionView.reloadData()
            }
        }
    }
    
    private func fetchImageFromCoreData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageData")
        
        do {
            guard let fetchedFromCoreData = try viewContext.fetch(fetchRequest) as? [ImageData] else { return
            }
            fetchedImagesFromCoreData = fetchedFromCoreData
        } catch let error {
            print(error)
        }
    }
    
    private func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.width / 2)
        collectionView.setCollectionViewLayout(layout, animated: false)
    }
}
