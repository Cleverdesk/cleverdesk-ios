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
        
        print(json)
        let text_s = (json as! Dictionary<NSString, NSString>)["text"]
        
        text = text_s as? String
    }
    
    func toUI(mask: CGRect) -> [UIView]? {
        if(text == nil){
            return nil
        }else{
            let label = UITableViewCell()
            label.textLabel?.text = text
            label.textLabel?.numberOfLines = 0
            return [label]
        }
    }
}
