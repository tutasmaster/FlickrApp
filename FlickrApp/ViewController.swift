//
//  ViewController.swift
//  FlickrApp
//
//  Created by formacao on 28/06/2021.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var collectionView: UICollectionView!
    var images : [UIImage] = []
    var imageCount = 0
    var currentImage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        loadImages()
    }

    func loadImages() {
        getFlickrPhotoSearchResponse(){
            response in
            guard let response = response else { return }

            
            self.imageCount = response.photos.photo.count
            
            self.currentImage = 0
            for page in response.photos.photo{
                print(page.id)
                getFlickrPhotoData(id: page.id){
                    response in
                    guard let response = response else {
                        print("No photo data found for " + page.id)
                        return }
                    print("Photo data found for " + page.id)
                    self.images.append(response)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        if(indexPath.item < images.count){
            
            cell.imageView.image = images[indexPath.item]
        }
        return cell
    }
}
