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
    var isLoading = true
    var page = 1
    var itemCount = 0
    var totalItemCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        loadImages(page: page)
    }

    func loadImages(page: Int) {
        isLoading = true
        getFlickrPhotoSearchResponse(page: page){
            response in
            guard let response = response else { return }
            self.totalItemCount+=response.photos.photo.count
            for page in response.photos.photo{
                print(page.id)
                var image = Image(id: page.id, data: nil)
                getFlickrPhotoData(id: page.id, label: "Large Square"){
                    response in
                    self.itemCount+=1
                    if self.itemCount == self.totalItemCount - 1{
                        self.isLoading = false
                        self.page+=1
                    }
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == images.count - 20 && !self.isLoading {
            loadImages(page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.imageView.image = images[indexPath.item].data
        return cell
    }
    @objc func dismissFullscreenImage(sender: UITapGestureRecognizer){
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    @IBAction func handleTap(_ sender: UITapGestureRecognizer) {
        print("tap")
        print(sender.view!)
        if let indexPath = collectionView.indexPathForItem(at: sender.location(in: collectionView)){
            let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
            let imageView = cell.imageView!
            let newImageView = UIImageView(image: imageView.image)
            newImageView.translatesAutoresizingMaskIntoConstraints = false
            let constraints = [
                newImageView.topAnchor.constraint(equalTo: view.topAnchor),
                newImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
                newImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
                newImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ]
            newImageView.backgroundColor = .black
            newImageView.contentMode = .scaleAspectFit
            newImageView.isUserInteractionEnabled = true
            var tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissFullscreenImage(sender:)))
            tap.numberOfTapsRequired = 1
            tap.numberOfTouchesRequired = 1
            newImageView.addGestureRecognizer(tap)
            self.view.addSubview(newImageView)
            self.navigationController?.isNavigationBarHidden = true
            self.tabBarController?.tabBar.isHidden = true
            NSLayoutConstraint.activate(constraints)
            
            getFlickrPhotoData(id: images[indexPath.item].id, label: "Large"){
                response in
                guard let response = response else {
                    return }
                DispatchQueue.main.async {
                    newImageView.image = response
                }
            }
        }
    }
}
