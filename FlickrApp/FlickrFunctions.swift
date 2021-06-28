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
            apiKey = key
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

func getImageDataURL(id : String) -> URL{
    return URL(string: "https://live.staticflickr.com/8424/" + id + "_8c6211646e_q.jpg")!
}

func getFlickrPhotoSearchResponse(finished: @escaping(_ isSuccess: Bool, _ response: FlickrPhotoSearchResponse?) -> ()){
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
            finished(true, parsedJSON)
            finished(false, nil)
        }catch{
            finished(false, nil)
        }
    }).resume()
}

func getFlickrPhotoData(id: String, finished: @escaping(_ isSuccess: Bool, _ response: UIImage?) -> ()){
    let url = getImageDataURL(id: id)
    URLSession.shared.dataTask(with: url, completionHandler: {
        data, response, error in
        guard let data = data else {
            print("Photo Data task has returned with no data.")
            finished(false, nil)
            return
        }
        finished(true, UIImage(data: data))
    })
}
