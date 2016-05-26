//
//  Label.swift
//  Cleverdesk
//
//  Created by Jonas Franz on 15.05.16.
//  Copyright © 2016 Cleverdesk. All rights reserved.
//

import Foundation
import UIKit

class TextArea: Component {
    
    var label: String?
    //Not supported
    //var enabled: Bool?
    var input_name: String?
    //Not supported
    //var placeholder: String?
    var value: String?
    var readOnly: Bool?
    
    func name() -> String {
        return  "TextArea"
    }
    
    func copy() -> Component {
        return TextArea()
    }
    
    func fromJSON(json: AnyObject){
        let dic = (json as! Dictionary<NSString, NSObject>)
        input_name = dic["input_name"] as? String
        //Enabled is unsupported
        //enabled = dic["enabled"] as? Bool
        //max is unsupported
        //max = dic["max"] as? Int
        label = dic["label"] as? String
        value = dic["value"] as? String
        readOnly = dic["readOnly"] as? Bool
        
    }
    
    func toUI(mask: CGRect) -> [UIView]? {
        
        let height = 16 * self.value!.rangeOfString("\n")!.count
        let input = UITextView(frame: CGRectMake(0, 0, mask.width, CGFloat(height)))
        input.editable = !readOnly!
        input.backgroundColor = UIColor.whiteColor()
        input.text = value
        input.font = UIFont.systemFontOfSize(14.0)
        input.textAlignment = .Left
        input.textColor = UIColor.blackColor()
        if label != nil {
            let label_v = UILabel(frame: CGRectMake(0, 0, 10, 12))
            label_v.text = label
            return [label_v, input]
            
        }
        return [input]
        
    }
    
    
}
