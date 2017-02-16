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
    
    var meme: Meme!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    // MARK: View controllers methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add edit button to navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(showMemeViewController))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // set image
        imageView.image = meme.memedImage
        
        // disable tabbar 
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // show tabbar
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    // MARK: Helper methods
    
    func showMemeViewController() {
        let memeViewController: MemeViewController
        memeViewController = storyboard?.instantiateViewController(withIdentifier: "MemeViewController") as! MemeViewController
        memeViewController.initMeme = meme
        present(memeViewController, animated: true, completion: nil)
    }
}
