//
//  Meme.swift
//  MemeMe
//
//  Created by Andreas Rueesch on 07.02.17.
//  Copyright © 2017 Andreas Rueesch. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    let topText: String
    let bottomText: String
    let originalImage: UIImage
    let memedImage: UIImage
    
    func asDictionary() -> Dictionary<String, Any> {
        var memeDict = [String: Any]()
        
        memeDict["topText"] = topText
        memeDict["bottomText"] = bottomText
        memeDict["originalImage"] = originalImage
        memeDict["memedImage"] = memedImage
        
        return memeDict
    }
    
    // MARK: Initializer methods
    
    init(topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
    
    init(fromImageWithDefaultValues image: UIImage) {
        topText = "TOP Label"
        bottomText = "BOTTOM Labe"
        originalImage = image
        memedImage = image
    }
}
