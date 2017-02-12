//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Andreas Rueesch on 11.02.17.
//  Copyright © 2017 Andreas Rueesch. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class MemeCollectionViewController: UICollectionViewController {

    // MARK: Members
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet var memeCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // MARK: View Controller methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO delete debugging images
        addSomeDefaultImagesOnStartUp()
        
        // navigation button on the right to add new meme
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showMemeViewController))
        
        // set layout of collection cells
        setFlowLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // reload data
        memeCollectionView.reloadData()
        
        // subscribe to notification center
        subscripeToDeviceRotation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // unsubscribe from notification center
        unsubscripeToDeviceRotation()
    }

    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let meme = appDelegate.memes[(indexPath as NSIndexPath).row]
        
        cell.imageView.image = meme.memedImage

        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meme = appDelegate.memes[(indexPath as NSIndexPath).row]
        
        // build present view controller
        let memePresentViewController: MemePresentViewController
        memePresentViewController = storyboard?.instantiateViewController(withIdentifier: "MemePresentViewController") as! MemePresentViewController
        memePresentViewController.meme = meme
        
        // add view controller to navigation stack
        navigationController?.pushViewController(memePresentViewController, animated: true)
    }
    
    
    // MARK: Notification subscriptions
    
    func subscripeToDeviceRotation() {
        NotificationCenter.default.addObserver(self, selector: #selector(setFlowLayout), name: .UIDeviceOrientationDidChange, object: nil)
    }
    
    func unsubscripeToDeviceRotation() {
        NotificationCenter.default.removeObserver(self, name: .UIDeviceOrientationDidChange, object: nil)
    }
    
    
    // MARK: Helper
    
    func setFlowLayout() {
        let space: CGFloat = 3.0
        let dimension: CGFloat
        
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            dimension = (view.frame.size.width - (2 * space)) / 3.0
        } else {
            dimension = (view.frame.size.width - (4 * space)) / 5.0
        }
        
        flowLayout.minimumLineSpacing = space
        flowLayout.minimumInteritemSpacing = space
        
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }

    // QUESTION - I'd like to move this to the MemeViewController class (or the AppDelgate class?) since I implemented the exact same function
    //            in the TableViewController class, but I was not able to call the prober selector from the bar item action. Could you give me 
    //            some hints? Thanks 
    func showMemeViewController() {
        let memeViewController: MemeViewController
        memeViewController = storyboard?.instantiateViewController(withIdentifier: "MemeViewController") as! MemeViewController
        present(memeViewController, animated: true, completion: nil)
    }
    
    
    func addSomeDefaultImagesOnStartUp() {
        appDelegate.memes.append(Meme(fromImageWithDefaultValues: UIImage(named: "IMG_0013")!))
        appDelegate.memes.append(Meme(fromImageWithDefaultValues: UIImage(named: "IMG_0018")!))
        appDelegate.memes.append(Meme(fromImageWithDefaultValues: UIImage(named: "IMG_0003")!))
        appDelegate.memes.append(Meme(fromImageWithDefaultValues: UIImage(named: "IMG_0021")!))
        appDelegate.memes.append(Meme(fromImageWithDefaultValues: UIImage(named: "IMG_0013")!))
        appDelegate.memes.append(Meme(fromImageWithDefaultValues: UIImage(named: "IMG_0018")!))
        appDelegate.memes.append(Meme(fromImageWithDefaultValues: UIImage(named: "IMG_0003")!))
        appDelegate.memes.append(Meme(fromImageWithDefaultValues: UIImage(named: "IMG_0021")!))
    }
}
