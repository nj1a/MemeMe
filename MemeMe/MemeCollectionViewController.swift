//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by NATHAN JIA on 2016-08-25.
//  Copyright © 2016 Nathan Jia. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        
        // add plus sign to nav bar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title:"Add", style: .Plain, target: self, action: #selector(MemeTableViewController.addMeme))
    }
    
    func addMeme() {
        performSegueWithIdentifier("collectionToAddMeme", sender: nil)
    }
    
}