//
//  ViewController.swift
//  MemeMe
//
//  Created by Jing on 2015-07-06.
//  Copyright (c) 2015 Jing. All rights reserved.
//

import UIKit

class MemeEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topField: UITextField!
    @IBOutlet weak var bottomField: UITextField!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    let DEFAULT_TOP_TEXT = "TOP"
    let DEFAULT_BOTTOM_TEXT = "BOTTOM"
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
     //   NSBackgroundColorAttributeName : UIColor.clearColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -4.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initField(DEFAULT_TOP_TEXT,textField: self.topField)
        initField(DEFAULT_BOTTOM_TEXT,textField: self.bottomField)
        
        shareButton.enabled = false
    }
    
    func initField(fieldText: String, textField: UITextField) {
        textField.text = fieldText
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.Center
        textField.borderStyle = .None
    }
    
    // When a user taps inside a textfield, the default text should clear, not user entered text
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == DEFAULT_TOP_TEXT || textField.text == DEFAULT_BOTTOM_TEXT {
            textField.text = ""
        }
    }
    
    // When a user presses return, the keyboard should be dismissed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
       
        // Check if the device has camera
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        // Subscribe to keyboard notifications to allow the view to raise when necessary
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotification()
    }
    
    // Keyboard show function
    func keyboardWillShow(notification: NSNotification) {
        
        if bottomField.isFirstResponder() {
          self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    // Keyboard hide function
    func keyboardWillHide(notification: NSNotification) {
        
        if bottomField.isFirstResponder() {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    // Get the keyboard's height
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    // Subscribe to show/hide the keyboard notificaitions
    func subscribeToKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // Unscribe to show/hide the keyboard notification
    func unsubscribeFromKeyboardNotification() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // imagePicker controller
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imagePickerView.contentMode = .ScaleAspectFit
            self.imagePickerView.image = image
            shareButton.enabled = true
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Cancel imagePicker controoler
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    // Create a meme object and add it to the memes array
    func save() {
        // Update the meme
        var meme = Meme(topText: topField.text, bottomText: bottomField.text, image: imagePickerView.image!, memedImage: generateMemedImage())
        
        // Add it to the memes array on the Application Delegate
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
    }
    
    func toolbarAppear (appearBool: Bool) {
        self.toolbar.hidden = appearBool
        self.navigationBar.hidden = appearBool
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        toolbarAppear(true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        toolbarAppear(false)
        
        return memedImage
    }
    
    @IBAction func share(sender: UIBarButtonItem) {
        var memedImage = generateMemedImage()
        
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        self.presentViewController(activityController, animated: true, completion: nil)
        
        activityController.completionWithItemsHandler = {(activityType:String!, completed: Bool,
            returnedItems: [AnyObject]!, error: NSError!) in
            
            if completed {
                if activityType == UIActivityTypeSaveToCameraRoll {
                    println("save")
                    self.save()
                    activityController.dismissViewControllerAnimated(true, completion: nil)
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                }
            }
        }
    }
    
    
    @IBAction func cancelEdit(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

