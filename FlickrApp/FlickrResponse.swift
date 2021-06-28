//
//  FlickrResponse.swift
//  FlickrApp
//
//  Created by formacao on 28/06/2021.
//

import Foundation

var apiKey : String?

struct FlickrPhotoSearchResponse: Codable {
    struct FlickrPageResponse: Codable{
        struct FlickrPhotoResponse: Codable{
            let id: String
            let owner: String
            let secret: String
            let server: String
            let farm: Int
            let title: String
            let ispublic: Int
            let isfriend: Int
            let isfamily: Int
        }
        let page: Int
        let pages: Int
        let perpage: Int
        let total: Int
        let photo: [FlickrPhotoResponse]
    }
    let photos: FlickrPageResponse
    let stat: String
}
