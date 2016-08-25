//
//  DetailViewController.swift
//  MemeMe
//
//  Created by NATHAN JIA on 2016-08-25.
//  Copyright © 2016 Nathan Jia. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var memedImageView: UIImageView!
    
    var meme: Meme!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.memedImageView!.image = meme.memedImage
    }
}