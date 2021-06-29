//
//  FlickrResponse.swift
//  FlickrApp
//
//  Created by formacao on 28/06/2021.
//

import Foundation

var apiKey : String?

struct FlickrPhotoSearchResponse: Codable {
    struct Photos: Codable{
        struct Photo: Codable{
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
        let photo: [Photo]
    }
    let photos: Photos
    let stat: String
}

struct FlickrPhotoGetSizesResponse: Codable
{
    struct Sizes: Codable{
        struct Size: Codable{
            let label: String
            let width: Int
            let height: Int
            let source: String
            let url: String
            let media: String
        }
        let canblog : Int
        let canprint : Int
        let candownload: Int
        let size: [Size]
    }
    let sizes : Sizes
    let stat: String
}
