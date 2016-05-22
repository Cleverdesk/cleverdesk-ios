//
//  UI.swift
//  Cleverdesk
//
//  Created by Jonas Franz on 15.05.16.
//  Copyright © 2016 Cleverdesk. All rights reserved.
//

import Foundation
import UIKit

class UI: ComponentGroup {
    
    
    
    func name() -> String {
        return "UI"
    }
    
    private var components: [Component] = []
    
    func addComponent(component: Component) {
        components.append(component)
    }
    
    func removeComponent(component: Component) {
        components.append(component)
    }
    
    func getComponents() -> [Component] {
        return components
    }
    
    func toUI(frame: CGRect) -> [UIView]? {
        var ret: [UIView] = [UIView]()
        for comp in components {
            if comp.toUI(frame) != nil {
                ret.appendContentsOf(comp.toUI(frame)!)
            }
        }
        return ret
    }
    
    func fromJSON(json: AnyObject) {
        print(json)
        let registry = ComponentRegistry()
        components.removeAll()
        let cont: NSDictionary = json as! NSDictionary
        for  pure in (cont["components"] as! NSArray) {
            if pure["name"] !=  nil {
                var comp = registry.getForName(pure["name"] as! String)
                
                if comp != nil{
                    
                    comp = comp!.copy()
                    if comp == nil {
                        return
                    }
                    comp?.fromJSON(pure)
                    components.append(comp!)
                }
            }
        }
    }
    
    func copy() -> Component {
        return UI()
    }
}