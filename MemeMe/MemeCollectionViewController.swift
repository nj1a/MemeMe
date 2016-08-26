//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by NATHAN JIA on 2016-08-25.
//  Copyright © 2016 Nathan Jia. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // retrive memes from appDelegate as reference as array in Swift is value type
    var memes: [Meme]! {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure collection cell space and size
        let space: CGFloat = 3.0
        
        let dimesion = UIDevice.currentDevice().orientation == UIDeviceOrientation.Portrait ?
            (self.view.frame.size.width - 2 * space) / 3.0 :
            (self.view.frame.size.height - 2 * space) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSizeMake(dimesion, dimesion)
        
        // add plus sign to nav bar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title:"Add", style: .Plain, target: self, action: #selector(MemeTableViewController.addMeme))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView!.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionCell", forIndexPath: indexPath) as! MemeCollectionCell
        let meme = memes[indexPath.row]
        cell.imageView.image = meme.memedImage
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    func addMeme() {
        performSegueWithIdentifier("collectionToAddMeme", sender: nil)
    }
}