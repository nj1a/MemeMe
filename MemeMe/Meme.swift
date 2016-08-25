//
//  Meme.swift
//  MemeMe
//
//  Created by NATHAN JIA on 2016-08-24.
//  Copyright © 2016 Nathan Jia. All rights reserved.
//

import Foundation
import UIKit

// stroage of memes
var memes = [Meme]()

struct Meme {
    var topText: String
    var bottomText: String
    var image: UIImage
    var memedImage: UIImage
}