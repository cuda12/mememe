//
//  PopSettingsViewController.swift
//  MemeMe
//
//  Created by Andreas Rueesch on 12.02.17.
//  Copyright © 2017 Andreas Rueesch. All rights reserved.
//

import UIKit

class PopSettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: members
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let fontTypes = ["Impact", "HelveticaNeue-CondensedBlack", "Arial"]
    
    var initBgColor: UIColor?
    var initFontType: String?
    
    @IBOutlet weak var sliderRed: UISlider!
    @IBOutlet weak var sliderGreen: UISlider!
    @IBOutlet weak var sliderBlue: UISlider!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var fontPicker: UIPickerView!
    
    
    // MARK: view controller methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // set color and font to given values (if available)
        setUItoInitValues()
        
        // change background to init value
        changeColor()
        
        preferredContentSize = CGSize(width: 300, height: 250)
    }
    
    
    // MARK: picker view delgate and data source methods
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return fontTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("im called \(row) \(component)")  // TODO delete
        appDelegate.settingsMemeVC["font"] = fontTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fontTypes.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    // MARK: actions
    
    @IBAction func changeColor() {
        let redColor = CGFloat(sliderRed.value)
        let greenColor = CGFloat(sliderGreen.value)
        let blueColor = CGFloat(sliderBlue.value)
        let bgColor = UIColor(red: redColor, green: greenColor, blue: blueColor, alpha: 1.0)
        
        colorView.backgroundColor = bgColor
        appDelegate.settingsMemeVC["bgColor"] = bgColor
    }
 
    
    // MARK: helpers
    func setUItoInitValues() {
        // set background color
        if let bgColor = initBgColor {
            sliderRed.value = Float(bgColor.cgColor.components![0])
            sliderGreen.value = Float(bgColor.cgColor.components![1])
            sliderBlue.value = Float(bgColor.cgColor.components![2])
        }
        
        // set font type
        if let font = initFontType {
            if let index = fontTypes.index(of: font) {
                fontPicker.selectRow(index, inComponent: 0, animated: false)
            }
        }
    }
    
}
