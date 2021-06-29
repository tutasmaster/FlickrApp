//
//  ViewController.swift
//  FlickrApp
//
//  Created by formacao on 28/06/2021.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var collectionView: UICollectionView!
    var images : [Image] = []
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
            for page in response.photos.photo{
                print(page.id)
                var image = Image(id: page.id, data: nil)
                getFlickrPhotoData(id: page.id, label: "Large Square"){
                    response in
                    guard let response = response else {
                        print("No photo data found for " + page.id)
                        return }
                    print("Photo data found for " + page.id)
                    image.data = response
                    self.images.append(image)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.imageView.image = images[indexPath.item].data
        return cell
    }
}
