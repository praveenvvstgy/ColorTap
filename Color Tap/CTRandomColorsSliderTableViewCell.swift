//
//  CTRandomColorsTableViewCell.swift
//  Color Tap
//
//  Created by Praveen Gowda I V on 1/25/16.
//  Copyright © 2016 Praveen Gowda I V. All rights reserved.
//

import UIKit

class CTRandomColorsTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var collectionViewOffset: CGFloat {
        get {
            return collectionView.contentOffset.x

        }
        set {
            collectionView.contentOffset.x = newValue
        }
    }
    
    func setCollectionViewDataSourceDelegate<D: protocol<UICollectionViewDataSource, UICollectionViewDelegate>>(dataSourceDelegate: D, forRow row: Int) {
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.setContentOffset(collectionView.contentOffset, animated: true)
        collectionView.reloadData()
    }
}
