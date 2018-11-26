//
//  FeaturedCell.swift
//  ShudderFeatured
//
//  Created by Qasim Abbas on 11/19/18.
//  Copyright © 2018 Qasim. All rights reserved.
//

import UIKit
///Cell that will be handling the Carousel with CollectionViews
class FeaturedCell: UITableViewCell {

    ///CollectionView where CarouselSets are set and items will be presented from dataCollection
    @IBOutlet weak var collectionView: CustomCollectionView!

    /// This sets the location of the off set of the CollectionView.  As the tableview is being scrolled and reusable cells are being dequed, this saves the last state of the CollectionView per row that it was scrolled to.
    var collectionViewOffset: CGFloat {
        get {
            return collectionView.contentOffset.x
        }

        set {
            collectionView.contentOffset.x = newValue
        }
    }

    /**
     CollectionView is to be set as a delegate per row and tagged to use as an identifier. CollectionView is also registering from the xib template
     
     - Parameters:
         - dataSourceDelegate: dataSourceDelegate: delegate of the collection view is being setup
         - row: the row of the cell the collection view is being setup for
     */
    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDataSource & UICollectionViewDelegate>
        (dataSourceDelegate: D, forRow row: Int, forIdentifier identifier: String) {

        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.identifier = identifier
        collectionView.register(UINib(nibName: "CarouselCell", bundle: Bundle.main), forCellWithReuseIdentifier: "Cell")
        collectionView.reloadData()
    }

}

///Creating a custom CollectionView to separate the identifiers of Banners and Carousel to reuse the CollectionView Carousel Implementation
class CustomCollectionView: UICollectionView {
    ///Identifier to differentiate a Carousel CollectionView and Banner CollectionView
    var identifier: String = ""
}
