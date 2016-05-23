//
//  ComponentRegistry.swift
//  Cleverdesk
//
//  Created by Jonas Franz on 15.05.16.
//  Copyright © 2016 Cleverdesk. All rights reserved.
//

import Foundation

class ComponentRegistry {
    var components: [Component] {
        get {
            var comps = [Component]()
            comps.append(Label())
            comps.append(InputField())
            comps.append(YouTubeVideo())
            return comps
        }
    }
    
    func getForName(name: String) -> Component? {
        for comp in components {
            if comp.name() == name{
                return comp
            }
        }
        return nil
    }
    
}