//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by NATHAN JIA on 2016-08-25.
//  Copyright © 2016 Nathan Jia. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // retrive memes from appDelegate
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        
        // add plus sign to nav bar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title:"Add", style: .Plain, target: self, action: #selector(MemeTableViewController.addMeme))
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        <#code#>
//    }
//    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        <#code#>
//    }
    
    func addMeme() {
        performSegueWithIdentifier("tableToAddMeme", sender: nil)
    }
    
}