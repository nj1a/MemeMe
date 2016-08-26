//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by NATHAN JIA on 2016-08-25.
//  Copyright © 2016 Nathan Jia. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    // retrive memes from appDelegate as reference as array in Swift is value type
    var memes: [Meme]! {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add plus sign to nav bar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title:"Add", style: .Plain, target: self, action: #selector(MemeTableViewController.addMeme))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell")!
        let meme = memes[indexPath.row]
        cell.textLabel!.text = meme.topText + "..." + meme.bottomText
        cell.imageView!.image = meme.memedImage
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    func addMeme() {
        performSegueWithIdentifier("tableToAddMeme", sender: nil)
    }
}