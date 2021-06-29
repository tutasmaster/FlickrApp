//
//  FlickrFunctions.swift
//  FlickrApp
//
//  Created by formacao on 28/06/2021.
//

import Foundation
import UIKit

func loadApiKey(){
    if let filepath = Bundle.main.path(forResource: "api_key", ofType: "txt"){
        do {
            let key = try String(contentsOfFile: filepath)
            apiKey = key.components(separatedBy: "\n")[0]
        }catch{
            print("Failed to read the API Key. api_key.txt may be corrupted.")
        }
    }else{
        print("API key was not bundled with the app. Please add it to api_key.txt.")
    }
}

func getSearchURL() -> URL{
    if(apiKey == nil){
        loadApiKey()
    }
    return URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=" + apiKey! + "&tags=bird&page=1&format=json&nojsoncallback=1")!
}

func getImageSizesURL(id : String) -> URL{
    if(apiKey == nil){
        loadApiKey()
    }
    return URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.getSizes&api_key=" + apiKey! + "&photo_id=" + id + "&format=json&nojsoncallback=1")!
}

func getImageSizes(id : String, finished: @escaping(_ response: FlickrPhotoGetSizesResponse?) -> ()){
    URLSession.shared.dataTask(with: getImageSizesURL(id: id), completionHandler: {
        data, response, error in
        guard let data = data else {
            print("Image URL returned no data.")
            return
        }
        let jsonDecoder = JSONDecoder()
        do{
            let parsedJSON = try jsonDecoder.decode(FlickrPhotoGetSizesResponse.self, from: data)
            finished(parsedJSON)
        }catch{
            finished(nil)
        }
    }).resume()
}

func getFlickrPhotoSearchResponse(finished: @escaping(_ response: FlickrPhotoSearchResponse?) -> ()){
    let url = getSearchURL()
    URLSession.shared.dataTask(with: url, completionHandler: {
        data, response, error in
        guard let data = data else {
            print("Photo Search task has returned no data.")
            return
        }
        let jsonDecoder = JSONDecoder()
        do{
            let parsedJSON = try jsonDecoder.decode(FlickrPhotoSearchResponse.self, from: data)
            finished(parsedJSON)
        }catch{
            finished(nil)
        }
    }).resume()
}

func findPhotoURLFromLabel(response: FlickrPhotoGetSizesResponse, label: String) -> URL?{
    for size in response.sizes.size{
        print(size.label)
        if size.label == label {
            return URL(string: size.source)
        }
    }
    return nil
}

func getFlickrPhotoData(id: String, label: String, finished: @escaping(_ response: UIImage?) -> ()){
    getImageSizes(id: id){
        response in
        
        if response == nil {
            print(id)
        }
        guard let photoURL = findPhotoURLFromLabel(response: response!, label: label) else {
            finished(nil)
            return
        }
        print(photoURL.absoluteString)
        URLSession.shared.dataTask(with: photoURL, completionHandler: {
            data, response, error in
            guard let data = data, error == nil else {
                print("Photo Data task has returned with no data.")
                finished(nil)
                return
            }
            finished(UIImage(data: data))
        }).resume()
    }
}
