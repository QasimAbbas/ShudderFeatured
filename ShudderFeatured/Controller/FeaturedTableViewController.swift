//
//  FeaturedTableViewController.swift
//  ShudderFeatured
//
//  Created by Qasim Abbas on 11/19/18.
//  Copyright © 2018 Qasim. All rights reserved.
//

import UIKit

class FeaturedTableViewController: UITableViewController {

    ///Storing the values of the offsets to saev locations of where CollectionViews have been scrolled to before dequeuing
    var storedOffsets = [Int: CGFloat]()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        visualElements()
    }

    /// Setting up the visual elements that such as colors for elements such as background for view and tableview. Calling this in viewWillAppear.
    func visualElements () {
        self.view.backgroundColor = backgroundColor
        self.tableView.separatorColor = UIColor.clear
        self.tableView.backgroundColor = backgroundColor

        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.8, height: self.view.bounds.height * 0.2))
        imageView.image = UIImage(named: "shudder")

        self.navigationItem.titleView = imageView

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let names = ["Horror", "Comedy", "Family", "Children", "SciFi", "Musical", "Film"]
        addCollectionSearchSetToDataCollection(names: names, completion: {
            DispatchQueue.main.async {
                self.sortDataCollection(names: names)
                 self.tableView.reloadData()
            }

        })
        self.tableView.reloadData()
    }

    func sortDataCollection(names: [String]) {
        let placeHolder = dataCollection
        dataCollection.removeAll()
        for name in names {
            for data in placeHolder where data.name == name {
                    dataCollection.append(data)

            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataCollection.count * 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row % 2 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath)
            //print(sequenNumber(integer: indexPath.row)+1)
            cell.textLabel?.text = dataCollection[sequenNumber(integer: indexPath.row)].name
            cell.backgroundColor = backgroundColor
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeaturedCell", for: indexPath)
            cell.backgroundColor = backgroundColor
            return cell
        }

    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? FeaturedCell else { return }

        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
        tableViewCell.contentView.frame = CGRect(x: 0, y: 0, width: 118, height: 118)
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? FeaturedCell else { return }
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return (indexPath.row % 2) != 0 ? 118 : 20
    }

    /**
     Take an even number of an odd number from a sequence of numbers and this converts it to the correspoding position of where that number is.
     1 -> 1
     3 -> 2
     5 -> 3
     
     - Parameters:
        - integer: pass the value that is from the sequence
    
     - Returns: Correspoinding integer position from ordering of 1,2,3 sequence
     
    */
    func sequenNumber(integer: Int) -> Int {
        return (integer % 2 ) == 0 ? (Int(ceil(Double(integer)/2))) : (Int(ceil(Double(integer)/2))-1)
    }
}

extension FeaturedTableViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.backgroundColor = backgroundColor
        return dataCollection[sequenNumber(integer: collectionView.tag)].itemSet.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CarouselCell else {
            return UICollectionViewCell()
        }

        cell.imageView.image = dataCollection[sequenNumber(integer: collectionView.tag)].itemSet[indexPath.row].image
        cell.backgroundColor = backgroundColor
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 78, height: 118)
    }

}
