//
//  MemePresentViewController.swift
//  MemeMe
//
//  Created by Andreas Rueesch on 11.02.17.
//  Copyright © 2017 Andreas Rueesch. All rights reserved.
//

import UIKit

class MemePresentViewController: UIViewController {

    // MARK: Members
    
    var memedImage: UIImage!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    // MARK: View controllers methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // set image
        imageView.image = memedImage
        
        // disable tabbar 
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // show tabbar
        self.tabBarController?.tabBar.isHidden = false
    }
}
