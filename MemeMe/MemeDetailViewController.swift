//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Jing on 2015-07-09.
//  Copyright (c) 2015 Jing. All rights reserved.
//

import UIKit


class MemeDetailViewController: UIViewController {
    
    var memes: Meme!
    
    @IBOutlet weak var imageDetailView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageDetailView.image = memes.memedImage
        imageDetailView.contentMode = .ScaleAspectFit
    }
}