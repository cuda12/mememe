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
    let memeTextAttributes:[String: Any] = [NSStrokeColorAttributeName: UIColor.black,
                                            NSForegroundColorAttributeName: UIColor.white ,
                                            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
                                            NSStrokeWidthAttributeName: -3.0]
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var camButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var labelTop: UITextField!
    @IBOutlet weak var labelBottom: UITextField!
    
    // MARK: View methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add attributes to text field and link delegate to MemeVC
        labelTop.defaultTextAttributes = memeTextAttributes
        labelTop.textAlignment = .center        // -- QUESTION Could I move this into the memeTextAttributes?
        labelTop.delegate = self
        
        labelBottom.defaultTextAttributes = memeTextAttributes
        labelBottom.textAlignment = .center
        labelBottom.delegate = self
        
        // clear any contents
        cancelMeme(self)
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
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        
        // disable add image buttons while text is added
        enableAddImgButtons(false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        // reenable buttons
        enableAddImgButtons(true)
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
    
    func keyboardWillShow(_ notification: Notification) {
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func keyboardWillHide() {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    // MARK: UI methods
    
    @IBAction func pickAnImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cancelMeme(_ sender: Any) {
        // clear the image View and reset the labels
        self.imagePickerView.image = nil
        self.labelTop.text = "TOP"
        self.labelBottom.text = "BOTTOM"
    }
    
    @IBAction func shareMeme(_ sender: Any) {
    }
    
    // MARK: helper functions
    
    func enableAddImgButtons(_ flag: Bool) {
        camButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera) && flag
        albumButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.photoLibrary) && flag
    }
    
}

