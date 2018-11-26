//
//  API.swift
//  ShudderFeatured
//
//  Created by Qasim Abbas on 11/19/18.
//  Copyright © 2018 Qasim. All rights reserved.
//

import Foundation

/// API Key from Flickr API
let apiKey = "api_key=830ea30aa4afaf2ca7ae4efca2e720ee"

/// API Secret Key from Flickr API
let secretKey = "3d2f3464673c86a3"

/// API EndPoint to access the FlickrAPI with correspoinding method parameter
let apiEndpoint = "https://api.flickr.com/services/rest/?method="

/**
 Gets a string and calls search calling the Flickr API and search for the string that was passed.  After found, the data of what is found is oassed to parseSearchObject to parse the search results into data which can be converted into images.
 
 - Parameters:
 - searchItem: The string to be searched by to find items from Flickr
 - completion: The completion handler that waits for all data to be parsed and converted, then returns an array of [Data]
 - result: [Data] that is returned back after data that was recieved was all parsed into Data objects
 */
func getSearch(searchItem: String, completion: @escaping (_ result: [Data]) -> Void) {

    let urlString = createSearchURLString(searchItem: searchItem)
    guard let url = URL(string: urlString) else { return }
    let session = URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let data = data {

            DispatchQueue.main.async {
                parseSearchObject(data: data, completion: { (dataArray) in
                    completion(dataArray)
                })
            }
        }

        if response != nil {
            //print(response ?? "no response")
        }

        if let error = error {
            print(error)
        }
    }
    session.resume()
}

/// Constructs the url that is used to create the search through the GET request for the Flickr API with all the needed parameters to return 25 search results.
/// - parameter searchItem: The string that is being used to search the Flickr API
/// - Returns: URL as String constructed with the string paraemeter and api keys as well as other search parameters.
func createSearchURLString(searchItem: String) -> String {
    let method = "flickr.photos.search"
    let parameters = "format=json&per_page=25"
    let jsonCallBack = "nojsoncallback=1"
    let searchEncoding = "\(apiEndpoint)\(method)&\(apiKey)&\(parameters)&\(jsonCallBack)&tags=\(searchItem)"
    return searchEncoding.replacingOccurrences(of: " ", with: "%20")
}

/**
 Takes the data object from **getSearch** and parses into a jsonObject.  Then the **photoData** is to be parsed into indidual images calling **photoData** method
 
 - Parameters:
 - data: Data from **getSearch**
 - completion: waiting for the Data recived from **getSearch** to be parsed into separate Data objects of image information.
 - dataArray: Returning the image that array [Data] that is being parsed.
 */
func parseSearchObject(data: Data, completion: @escaping (_ dataArray: [Data]) -> Void) {

    do {
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        guard let photos = json?["photos"] as? [String: Any] else { return }
        guard let photo = photos["photo"] as? [Any] else { return }
        photoData(photo: photo) { (dataArray) in
//            print("DATA ITEMS RECIEVED \(dataArray.count)")
            completion(dataArray)
        }
    } catch {
        print("Error parsing")
    }
}

/**
 Photo parameter from the json that is received the **getSearch** needs to be extraced and then photo data needs to be extraed to get Data of images to be used to load into imageViews.  This requires another Flickr API call that will get image information from parameters recived from Data from **getSearch** of the set of photos.  This uses multiple threads to recieve the information in parallel to save on computing over a longer period of time since each image needs to be fetched one by one.
 - Parameters:
 - photo: Photo object from the json that is being converted by **parseSearchObject**
 - completion: A FlickrAPI Call in the method **createFarm** to get actual image Data that will be returned as a set of Data objects in [Data]
 
 - result: [Data] of image data recived from Flickr API
 */

func photoData(photo: [Any], completion: @escaping (_ result: [Data]) -> Void) {
    var photoDataArray = [Data]()
    //print("AMOUNT OF PHOTO ITEMS \(photo.count)")
    for (index, photoItem) in photo.enumerated() {
        guard let info = photoItem as? [String: Any] else { return }
        guard let identifier = info["id"] as? String else { return }
        guard let secret = info["secret"] as? String else { return }
        guard let farm = info["farm"] as? Int else { return }
        guard let server = info["server"] as? String else { return }
        DispatchQueue.global(qos: .userInitiated).sync {
            let group = DispatchGroup()
            group.enter()
            createFarm(farmID: farm, serverID: server, photoID: identifier, secretID: secret) { (data) in
                photoDataArray.append(data)
                group.leave()
                if index == photo.count-1 {
                    group.wait()
                    completion(photoDataArray)

                }
            }
//            group.notify(queue: .main, execute: {
//                completion(photoDataArray)
//            })
        }
    }
}

/**
 Calls to the Flickr API with parameters that are need to construct the call to recive image Data
 
 - Parameters:
 - farmID: ID of the farm used to get image from Flickr API
 - serverID: ID of the server used to get image from Flickr API
 - photoID: ID of the photo used to get image from Flickr API
 - secretID: ID of the secret used to get image from Flickr API
 - completion: callback from the method once image data is recieved
 - result: return image Data that is recived from FLickr API
 */
func createFarm(farmID: Int, serverID: String, photoID: String, secretID: String, completion: @escaping (_ result: Data) -> Void) {

    let farm = "https://farm\(farmID).staticflickr.com/\(serverID)/\(photoID)_\(secretID).jpg"
    guard let url = URL(string: farm) else {return }
    let session = URLSession.shared.dataTask(with: url ) { (data, response, error) in
        if let data = data {
            DispatchQueue.main.async {
                completion(data)
            }
        }
        if response != nil {
            //print(response?.description ?? "no response")
        }

        if let error = error {
            print(error)
        }

    }
    session.resume()

}
