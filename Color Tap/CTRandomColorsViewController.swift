//
//  CTRandomColorsTableViewController.swift
//  Color Tap
//
//  Created by Praveen Gowda I V on 1/25/16.
//  Copyright © 2016 Praveen Gowda I V. All rights reserved.
//

import UIKit
import RandomColorSwift

class CTRandomColorsTableViewController: UITableViewController {
    
    var randomColors: [[UIColor]]?
    
    let Hues = [Hue.Monochrome : "Blacks and Whites", Hue.Red: "Reds", Hue.Orange: "Oranges", Hue.Yellow: "Yellows", Hue.Green: "Greens", Hue.Blue: "Blues", Hue.Purple: "Purples", Hue.Pink: "Pinks"]
    
    var storedOffsets = [Int: CGFloat]()
    
    private var sliderValue: Int = 0 {
        willSet {
            randomColors![9] = randomColorsCount(10, hue: .Value(Int(newValue)), luminosity: .Bright)
            tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 9)], withRowAnimation: .None)
        }
    }
    
    private var luminosity: Luminosity = .Bright {
        didSet {
            self.refreshColors()
        }
    }
    
    func hueFromInt(i: Int) -> Hue {
        switch i {
        case 0:
            return Hue.Monochrome
        case 1:
            return Hue.Red
        case 2:
            return Hue.Orange
        case 3:
            return Hue.Yellow
        case 4:
            return Hue.Green
        case 5:
            return Hue.Blue
        case 6:
            return Hue.Purple
        case 7:
            return Hue.Pink
        case 8:
            return Hue.Random
        default:
            return Hue.Value(sliderValue)
        }
    }
    
    override func viewDidLoad() {
        addColors()
    }
    
    @IBAction func refreshColors() {
        addColors()
        self.tableView.reloadData()
    }
    
    @IBAction func toggleLuminosity(sender: UIBarButtonItem) {
        if luminosity == .Bright {
            luminosity = .Dark
            sender.image = UIImage(named: "dark-selected")
        } else {
            luminosity = .Bright
            sender.image = UIImage(named: "dark")
        }
    }
    
    func addColors() {
        randomColors = []
        for i in 0...9 {
            randomColors?.append(randomColorsCount(10, hue: hueFromInt(i), luminosity: luminosity))
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 10
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 9 {
            return "Custom Color"
        }
        return String(hueFromInt(section))
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 9 {
            return 2
        } else {
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 9 && indexPath.row == 0 {
             return 48
        } else {
            return 86
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        if indexPath.section == 9 {
            if indexPath.row == 0 {
                cell = tableView.dequeueReusableCellWithIdentifier("SliderCell")
                let slider = cell.viewWithTag(1) as! GradientSlider
                slider.thumbColor = UIColor(hue: CGFloat(sliderValue)/360, saturation: 1, brightness: 1, alpha: 1)
                slider.actionBlock = { slider, value in
                    self.sliderValue = Int(value)
                    
                    CATransaction.begin()
                    CATransaction.setValue(true, forKey: kCATransactionDisableActions)
                    slider.thumbColor = UIColor(hue: value/360, saturation: 1, brightness: 1, alpha: 1)
                    
                    CATransaction.commit()
                }
            } else {
                cell = tableView.dequeueReusableCellWithIdentifier("RowCell") as! CTRandomColorsTableViewCell
            }
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("RowCell") as! CTRandomColorsTableViewCell
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let tableViewCell = cell as? CTRandomColorsTableViewCell else { return
        }
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.section)
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.section] ?? 0
    }
    
    override func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let tableViewCell = cell as? CTRandomColorsTableViewCell else { return
        }
        storedOffsets[indexPath.section] = tableViewCell.collectionViewOffset
    }
}

extension CTRandomColorsTableViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ColorCell", forIndexPath: indexPath)
        cell.backgroundColor = randomColors![collectionView.tag][indexPath.item]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
    }
    
//    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
//        var reusableView: UICollectionReusableView?
//        if kind == UICollectionElementKindSectionFooter {
//            let footerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "FooterView", forIndexPath: indexPath)
//            reusableView = footerView
//        }
//        return reusableView!
//    }
}