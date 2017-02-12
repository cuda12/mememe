//
//  MemeViewController.swift
//  MemeMe
//
//  Created by Andreas Rueesch on 06.02.17.
//  Copyright © 2017 Andreas Rueesch. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    // MARK: Member variables
    
    let placeholdersTextFields: [String: String] = ["topLabel": "TOP", "bottomLabel": "BOTTOM"]
    
    var activeTextField: UITextField?
    var initMeme: Meme?
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var camButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var labelTop: UITextField!
    @IBOutlet weak var labelBottom: UITextField!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var navigationbar: UINavigationBar!
    
    // MARK: View methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add attributes to text field and link delegate to MemeVC
        setTextFieldAttributes(textField: labelTop)
        setTextFieldAttributes(textField: labelBottom)
        
        // init UIViews with default values
        initUIViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // enable buttons where the source is available
        enableAddImgButtons(true)
        
        // subscribe to keyboard notification
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // unsubscribe to keyboard notification
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Delegates methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            setControlButtons(forImageAvailable: true)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // only clear text if its equal to placeholder
        if placeholdersTextFields.values.contains(textField.text!) {
            textField.text = ""
        }
        
        // disable add image buttons while text is added
        enableAddImgButtons(false)
        
        // registrate as activeTextField (so only one field gets edited at the time and keyboard is proberly shown)
        activeTextField = textField
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // only allow one text field at the time to be edited
        if activeTextField == nil {
            return true
        } else {
            return false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        // reenable buttons
        enableAddImgButtons(true)
        
        // deregistrate textfield from activeTextfield variable
        activeTextField = nil
        
        return true
    }
    
    
    // MARK: Notifications
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }

    
    // MARK: UI methods
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        pickAnImage(fromSource: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickAnImage(fromSource: .camera)
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        let imageMemed: UIImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [imageMemed], applicationActivities: nil)
        
        // make use of the completionWithItemsHandler closure to store the memed image
        activityController.completionWithItemsHandler = { activity, success, items, error in
            if success {
                self.saveMeme(memedImage: imageMemed)
                self.dismissMemeViewController()
            }
        }
        
        present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func cancelMeme(_ sender: Any) {
        // clear the image View and reset the labels
        // if no meme is available dismiss view controller 
        
        if imagePickerView.image != nil {
            initUIViews()
        } else {
            dismissMemeViewController()
        }
        
    }

    
    // MARK: helper functions
    
    func setTextFieldAttributes(textField: UITextField) {
        let memeTextAttributes: [String: Any] = [NSStrokeColorAttributeName: UIColor.black,
                                                 NSForegroundColorAttributeName: UIColor.white ,
                                                 NSFontAttributeName: UIFont(name: "Impact", size: 40)!,
                                                 NSStrokeWidthAttributeName: -3.0]
        
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.delegate = self
    }
    
    func initUIViews() {
        // in case no meme was given on start up init with default values, otherwise with given meme
        if let initMeme = self.initMeme {
            imagePickerView.image = initMeme.originalImage
            labelTop.text = initMeme.topText
            labelBottom.text = initMeme.bottomText
            setControlButtons(forImageAvailable: true)
        } else {
            imagePickerView.image = nil
            labelTop.text = placeholdersTextFields["topLabel"]
            labelBottom.text = placeholdersTextFields["bottomLabel"]
            setControlButtons(forImageAvailable: false)
        }
    }
    
    func setControlButtons(forImageAvailable flag: Bool) {
        shareButton.isEnabled = flag
        cancelButton.title = flag ? "Cancel" : "Dismiss"
    }
    
    func pickAnImage(fromSource source: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        // hide toolbar and navbar
        navigationbar.isHidden = true
        toolbar.isHidden = true
        
        // render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // show toolbar and navbar
        navigationbar.isHidden = false
        toolbar.isHidden = false
    
        return memedImage
    }
    
    func saveMeme(memedImage: UIImage) {
        let memeMe = Meme(topText: labelTop.text!, bottomText: labelBottom.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        
        // add meme to application delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(memeMe)
    }
    
    func enableAddImgButtons(_ flag: Bool) {
        camButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera) && flag
        albumButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.photoLibrary) && flag
    }
    
    func keyboardWillShow(_ notification: Notification) {
        // only shift if activeTextField would be coverd by the keyboard
        let keyboardHeight: CGFloat = getKeyboardHeight(notification)
        let viewHeight: CGFloat = view.frame.height
        
        if let activeTextFieldPosY = activeTextField?.frame.origin.y {
            let diffTextFieldKeyboard = (viewHeight - keyboardHeight) - activeTextFieldPosY
            if diffTextFieldKeyboard < 0 {
                view.frame.origin.y = -keyboardHeight
            }
        }
    }
    
    func keyboardWillHide() {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func dismissMemeViewController() {
        dismiss(animated: true, completion: nil)
    }
}


