//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Jing on 2015-07-07.
//  Copyright (c) 2015 Jing. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController : UITableViewController  {
    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        
        memes = applicationDelegate.memes
      //  tableView.reloadData()
    }
    override func viewWillAppear(animated: Bool) {
        // Refresh the local memes
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        
        memes = applicationDelegate.memes
        // Refresh the table list
        tableView.reloadData()
    }
    
    // MARK: Table View Data Source
        
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
        
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableCell") as! MemeTableCell
        let meme = self.memes[indexPath.row]
        
        // Set the name and image
        cell.memeImageView.image = meme.image
        
//        cell.memeImageView.contentMode = .ScaleAspectFit
        
        cell.setText(meme.topText, bottomText: meme.bottomText)
    
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let memeDetailController = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailView") as! MemeDetailViewController
        
        memeDetailController.memes = self.memes[indexPath.row]
        self.navigationController!.pushViewController(memeDetailController, animated: true)
    }
    
    // Presents the meme editor
    @IBAction func presentMemeEditor(sender: UIBarButtonItem) {
        let memeEditController = storyboard!.instantiateViewControllerWithIdentifier("MemeEditViewController") as! MemeEditViewController
        
        presentViewController(memeEditController, animated: true, completion: nil)
    }

}
