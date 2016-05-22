//
//  Label.swift
//  Cleverdesk
//
//  Created by Jonas Franz on 15.05.16.
//  Copyright © 2016 Cleverdesk. All rights reserved.
//

import Foundation
import UIKit

class InputField: Component{
    
    var label: String?
    var enabled: Bool?
    var input_name: String?
    var placeholder: String?
    var value: String?
    
    func name() -> String {
        return  "InputField"
    }
    
    func copy() -> Component {
        return InputField()
    }
    
    func fromJSON(json: AnyObject){
        let dic = (json as! Dictionary<NSString, NSObject>)
        input_name = dic["input_name"] as? String
        enabled = dic["enabled"] as? Bool
        //max is unsupported
        //max = dic["max"] as? Int
        label = dic["label"] as? String
        placeholder = dic["placeholder"] as? String
        value = dic["value"] as? String
        
    }
    
    func toUI(mask: CGRect) -> [UIView]? {
        
        
        let input = UITextField(frame: mask)
        input.placeholder = placeholder
        if enabled != nil {
            input.enabled = enabled!
        }
        input.text = value
        
        if label != nil {
            let label_v = UILabel()
            label_v.text = label
            label_v.frame = CGRectMake(0, 0, 10, 12)
            return [label_v, input]
            
        }
        return [input]
        
    }
}
