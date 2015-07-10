//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Jing on 2015-07-07.
//  Copyright (c) 2015 Jing. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController : UICollectionViewController {
    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        
        memes = applicationDelegate.memes
    }
    
    override func viewWillAppear(animated: Bool) {
        // Refresh the local memes
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        
        memes = applicationDelegate.memes
        // Refresh the collection list
        collectionView?.reloadData()
    }
    
    // Collection View Data Source
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.item]
        
        // Set the name and image
        cell.setText(meme.topText, bottomText: meme.bottomText)
        cell.imageView.image = meme.image
        cell.imageView.contentMode = .ScaleAspectFill
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        //Grab the DetailViewController from storyboard
        let collectionVC = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailView") as! MemeDetailViewController
        
        //Populate view controller with data from the selected item
        collectionVC.memes = self.memes[indexPath.item]
        
        //Present the view controller using navigation
        self.navigationController!.pushViewController(collectionVC, animated: true)
    }
    
    // Presents the meme editor
    @IBAction func presentMemeEditor(sender: UIBarButtonItem) {
        let memeEditController = storyboard!.instantiateViewControllerWithIdentifier("MemeEditViewController") as! MemeEditViewController
        
        presentViewController(memeEditController, animated: true, completion: nil)
    }

}
