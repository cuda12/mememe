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
    let memes = (UIApplication.shared.delegate as! AppDelegate).memes
    
    // MARK: View controller methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // navigation button to add new meme
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showMemeViewController))
    }

    
    // MARK: Table View and Data Source methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // todo present detail view controller
    }
    
    
    // MARK: Helpers
    
    func showMemeViewController() {
        let memeViewController: MemeViewController
        memeViewController = storyboard?.instantiateViewController(withIdentifier: "MemeViewController") as! MemeViewController
        present(memeViewController, animated: true, completion: nil)
    }
}
