//
//  DataObjects.swift
//  ShudderFeatured
//
//  Created by Qasim Abbas on 11/19/18.
//  Copyright © 2018 Qasim. All rights reserved.
//

import Foundation
import UIKit

var bannerCollection: [CarouselSet] = [CarouselSet]()

///Set of CarouselSets that is recieved to load into the FeaturedTableViewController
var dataCollection: [CarouselSet] = [CarouselSet]() {
    willSet {
        //print("I am changing data Collection")
    }

    didSet {
         //print("I have changed")
    }
}

///Background color of views
var backgroundColor = UIColor(red: 23/255, green: 31/255, blue: 34/255, alpha: 1)
///Title colors and section colors for separators and headings
var sectionColor = UIColor(red: 105/255, green: 114/255, blue: 117/255, alpha: 1)

///Object used to create Carousel Sets.  Data to be loading into CollectionViews.
class CarouselSet: NSObject {
    ///Index of the CarouselSet in dataCollection
    var index: Int?
    ///Name of the CarouselSet, also acts as the section name
    var name: String?
    ///[CarouselItem] that will be carried
    var itemSet: [CarouselItem] = [CarouselItem]()

    ///Initialzing name of CarouselSet
    init(name: String) {
        self.name = name
    }
}

/// Objects to create items that will be loaded into CollectionViews.
class CarouselItem: NSObject {
    ///Ordering of the items
    var index: Int?
    ///Image to be loaded from fetched image Data
    var image: UIImage?

    ///Setting the image name for local images
    init(imageName: String) {
        self.image = UIImage(named: imageName)
    }

    ///Setting the images with Data
    init(imageData: Data) {
        self.image = UIImage(data: imageData)
    }
}

/// Takes [Data] of image Data and converts into [CarouselItem]
/// - parameter data: [Data] of image Data
/// - Returns [CarouselItem] that is created
func dataArrayToCarouselItems(data: [Data]) -> [CarouselItem] {
    var returnArray = [CarouselItem]()
    for (index, element) in data.enumerated() {
        let item = CarouselItem(imageData: element)
        item.index = index
        returnArray.append(item)
    }

    return returnArray
}

/// Take [String] of searches for Flickr API and do searches to recieve back and create [CarouselItems] and append them **dataCollection**
/// - parameter names: [String] of words to be searched and created
/// - parameter completion: callback for once the [CarouselSets] have been created and added to **dataCollection** to be loaded into **FeaturedTableViewController**
func addCollectionSearchSetToDataCollection(names: [String], completion: @escaping () -> Void) {

    var start = 0
    DispatchQueue.global(qos: .userInitiated).sync {
        for name in names {
            let group = DispatchGroup()
            group.enter()
            getSearch(searchItem: name) { (data) in
                let carouselSet = CarouselSet(name: name)
                carouselSet.itemSet = dataArrayToCarouselItems(data: data)
//                print("RETURNED ITEMS \(carouselSet.itemSet.count)")
                dataCollection.append(carouselSet)
                group.leave()
                start += 1
//                print("THREAD COUNT \(start)")

            }
            group.notify(queue: .main, execute: {
//                print("CALL BACK")
                completion()
            })

        }
    }
}

/// Take [String] of searches for Flickr API and do searches to recieve back and create [CarouselItems] and append them **bannerCollection**
/// - parameter names: [String] of words to be searched and created
/// - parameter completion: callback for once the [CarouselSets] have been created and added to **dataCollection** to be loaded into **FeaturedTableViewController**
func addCollectionSearchSetToBannerCollection(names: [String], completion: @escaping () -> Void) {

    var start = 0
    DispatchQueue.global(qos: .userInitiated).sync {
        for name in names {
            let group = DispatchGroup()
            group.enter()
            getSearch(searchItem: name) { (data) in
                let carouselSet = CarouselSet(name: name)
                carouselSet.itemSet = dataArrayToCarouselItems(data: data)
//                print("RETURNED ITEMS \(carouselSet.itemSet.count)")
                bannerCollection.append(carouselSet)
                group.leave()
                start += 1
//                print("THREAD COUNT \(start)")

            }
            group.notify(queue: .main, execute: {
//                print("CALL BACK")
                completion()
            })

        }
    }
}
