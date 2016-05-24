//
//  RadioButton.swift
//  Cleverdesk
//
//  Created by Matthias Kremer on 24.05.16.
//  Copyright © 2016 Cleverdesk. All rights reserved.
//

import Foundation
import UIKit

class RadioButton: Component{
    
    var value: String?
    var enabled: Bool?
    var input_name: String?
    var label: String?
    var selected: Bool?
    
    func name() -> String {
        return "RadioButton"
    }
    func copy() -> Component {
        return RadioButton()
    }
    func fromJSON(json: AnyObject){
        let dic = (json as! Dictionary<NSString, NSObject>)
        input_name = dic["input_name"] as? String
        enabled = dic["enabled"] as? Bool
        value = dic["value"] as? String
        selected = dic["selected"] as? Bool
        label = dic["label"] as? String
        
    }
    func toUI(frame: CGRect) -> [UIView]? {
        return[]
        
    }
    
    
    
}