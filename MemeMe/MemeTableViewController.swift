//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Andreas Rueesch on 11.02.17.
//  Copyright © 2017 Andreas Rueesch. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: class members (properties)
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var memeTableView: UITableView!
    
    // MARK: View controller methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // navigation button to add new meme
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showMemeViewController))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // reload table view to fetch new inserted memes
        memeTableView.reloadData()
    }
    
    // MARK: Table View and Data Source methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell")!
        let meme = appDelegate.memes[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = "\(meme.topText) \(meme.bottomText)"
        cell.imageView?.image = meme.memedImage
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // get current meme
        print("im called")
        let meme = appDelegate.memes[(indexPath as NSIndexPath).row]
        
        // build detailed (present) View Controller for memed image
        let memePresentViewController: MemePresentViewController
        memePresentViewController = storyboard?.instantiateViewController(withIdentifier: "MemePresentViewController") as! MemePresentViewController
        memePresentViewController.memedImage = meme.memedImage
        
        // add to navigation controller
        self.navigationController!.pushViewController(memePresentViewController, animated: true)
    }
    
    
    // MARK: Helpers
    
    func showMemeViewController() {
        let memeViewController: MemeViewController
        memeViewController = storyboard?.instantiateViewController(withIdentifier: "MemeViewController") as! MemeViewController
        present(memeViewController, animated: true, completion: nil)
    }
}
