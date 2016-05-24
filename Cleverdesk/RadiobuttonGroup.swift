//
//  RadioButtonGroup.swift
//  Cleverdesk
//
//  Created by Matthias Kremer on 24.05.16.
//  Copyright © 2016 Cleverdesk. All rights reserved.
//

import Foundation
import UIKit


class RadioButtonGroup: UIViewController, Component, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    var enabled: Bool?
    var input_name: String?
    var value: Int?
    var radioButtons = [RadioButton]()
    
    
    func name() -> String {
        return  "RadiobuttonGroup"
    }
    
    func copy() -> Component {
        return RadioButtonGroup()
    }
    
    func fromJSON(json: AnyObject){
        let dic = (json as! Dictionary<NSString, NSObject>)
        input_name = dic["input_name"] as? String
        enabled = dic["enabled"] as? Bool
        value = dic["value"] as? Int
        
        let radioButtonsData = dic["radioButtons"] as? [AnyObject]
        for rButtonData in radioButtonsData!{
            let rButton = RadioButton()
            rButton.fromJSON(rButtonData)
            radioButtons.append(rButton)
        }
        
    }
    
    func toUI(frame: CGRect) -> [UIView]? {
        
        
        let input = UIPickerView(frame: CGRectMake(0,0,0,60))
        if enabled != nil {
            input.userInteractionEnabled = enabled!
        }
        input.frame.height
        input.dataSource = self
        input.delegate = self
        input.reloadAllComponents()
        return [input]
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return radioButtons.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return radioButtons[component].value
    }
    

}