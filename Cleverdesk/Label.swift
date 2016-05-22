//
//  Label.swift
//  Cleverdesk
//
//  Created by Jonas Franz on 15.05.16.
//  Copyright © 2016 Cleverdesk. All rights reserved.
//

import Foundation
import UIKit

class Label: Component{
    
    var text: String?
    
    func name() -> String {
        return  "Label"
    }
    
    func copy() -> Component {
        return Label()
    }
    func fromJSON(json: AnyObject){
        
        text = (json as! Dictionary<String, String>)["text"]
    }
    
    func toUI(mask: CGRect) -> [UIView]? {
        if(text == nil){
            return nil
        }else{
            let label = UILabel(frame: mask)
            label.text = text
            return [label]
        }
    }
}
