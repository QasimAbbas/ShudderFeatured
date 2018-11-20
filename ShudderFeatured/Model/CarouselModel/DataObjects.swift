//
//  DataObjects.swift
//  ShudderFeatured
//
//  Created by Qasim Abbas on 11/19/18.
//  Copyright © 2018 Qasim. All rights reserved.
//

import Foundation
import UIKit

///Set of CarouselSets that is recieved to load into the FeaturedTableViewController
var dataCollection: [CarouselSet] = [CarouselSet]()

///Background color of views
var backgroundColor = UIColor(red: 23/255, green: 31/255, blue: 34/255, alpha: 1)
///Title colors and section colors for separators and headings
var sectionColor = UIColor(red: 105/255, green: 114/255, blue: 117/255, alpha: 1)

///Object used to create Carousel Sets.  Data to be loading into CollectionViews.
class CarouselSet: NSObject {
    var index: Int?
    var name: String?
    var itemSet: [CarouselItem] = [CarouselItem]()

    init(name: String) {
        self.name = name
    }
}

/// Objects to create items that will be loaded into CollectionViews.
class CarouselItem: NSObject {
    var index: Int?
    var image: UIImage?

    init(imageName: String) {
        self.image = UIImage(named: imageName)
    }

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

    DispatchQueue.global(qos: .userInitiated).async {
        for (index, name) in names.enumerated() {
            let group = DispatchGroup()
            group.enter()
            getSearch(searchItem: name) { (data) in
                let carouselSet = CarouselSet(name: name)
                carouselSet.itemSet = dataArrayToCarouselItems(data: data)
                dataCollection.append(carouselSet)
                group.leave()

            }
            if index == names.count-1 {
                print(index)
                group.wait()
                completion()
            }

        }
    }

}
