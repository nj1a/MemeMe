//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by NATHAN JIA on 2016-08-22.
//  Copyright © 2016 Nathan Jia. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UITextFieldDelegate,
    UINavigationControllerDelegate, UIImagePickerControllerDelegate{

    // MARK: outlets
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    // attributes for the top and bottom textfields
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size:
            40)!,
        NSStrokeWidthAttributeName: -3.5
    ]

    var memedImage: UIImage!
    
    // MARK: inherited
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureTextFields(topTextField)
        configureTextFields(bottomTextField)
    }
    
    override func viewWillAppear(animated: Bool) {
        // disable the camera button when the camera is not available
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.Camera)
        
        shareButton.enabled = imagePickerView.image != nil ? true : false
        
        // subscribe to the keyboard notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector:
            #selector(MemeEditorViewController.keyboardWillShow(_:)), name:
            UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:
            #selector(MemeEditorViewController.keyboardWillHide(_:)), name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        // unsubscribe from notifications
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        // hide status bar
        return true
    }
    
    // MARK: actions

    // delegate the imagepicker when album cliced
    @IBAction func pickImageFromAlbum(sender: AnyObject) {
        pickImageFromSource(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    // delegate the imagepicker when camera cliced
    @IBAction func pickImageFromCamera(sender: AnyObject) {
        pickImageFromSource(UIImagePickerControllerSourceType.Camera)
    }
    
    @IBAction func shareMeme(sender: AnyObject) {
        self.memedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems:
            [self.memedImage], applicationActivities: nil)
        
        // save meme to shared storage once action completed in activity view
        controller.completionWithItemsHandler = {
            activity, completed, items, error in
            if completed {
                self.saveMeme()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func configureTextFields(textField: UITextField) {
        // the centre has to be applied after attr are set to work properly
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.Center
    }
    
    func pickImageFromSource(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: image delegate
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info:
                                [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: text delegate
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField.text == "Top" || textField.text == "Bottom") {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // resume placeholder text if empty
        if (topTextField.text == "") {
            topTextField.text = "Top"
        } else if (bottomTextField.text == "") {
            bottomTextField.text = "Bottom"
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: notifications
    
    // move the view by the height of the keyboard
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            let keyboardHeight = getKeyboardHeight(notification)
            self.view.frame.origin.y -= keyboardHeight
        }
    }
    
    // resume original position of the view
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            let keyboardHeight = getKeyboardHeight(notification)
            self.view.frame.origin.y += keyboardHeight
        }
    }
    
    // retrive height of keyboard
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userinfo = notification.userInfo
        let keyboardSize = userinfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func generateMemedImage() -> UIImage {
        // hide toolbar and navbar
        topToolbar.hidden = true
        bottomToolbar.hidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        
        let memedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // show toolbar and navbar
        topToolbar.hidden = false
        bottomToolbar.hidden = false
        
        return memedImage
    }
    
    // generate meme object
    func saveMeme() {
        let meme = Meme(topText: topTextField.text!, bottomText:
            bottomTextField.text!, image: imagePickerView.image!, memedImage:
            self.memedImage)
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
    }
}