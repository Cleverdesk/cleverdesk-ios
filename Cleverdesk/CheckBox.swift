//
//  CheckBox.swift
//  Cleverdesk
//
//  Created by Matthias Kremer on 24.05.16.
//  Copyright © 2016 Cleverdesk. All rights reserved.
//

import Foundation
import UIKit

class CheckBox: Component{
    
    var value: Bool?
    var enabled: Bool?
    var input_name: String?
    
    func name() -> String {
        return "CheckBox"
    }
    func copy() -> Component {
        return CheckBox()
    }
    func fromJSON(json: AnyObject){
        let dic = (json as! Dictionary<NSString, NSObject>)
        input_name = dic["input_name"] as? String
        enabled = dic["enabled"] as? Bool
        value = dic["value"] as? Bool
        
    }
    func toUI(frame: CGRect) -> [UIView]? {
        let checkBox = UISwitch(frame: frame)
        if let state = value{
            checkBox.on = state
        }
        if let usable = enabled{
            checkBox.enabled = usable
        }
        return [checkBox]
        
    }

    

}