//
//  ComponentGroup.swift
//  Cleverdesk
//
//  Created by Jonas Franz on 15.05.16.
//  Copyright © 2016 Cleverdesk. All rights reserved.
//

import Foundation

protocol ComponentGroup : Component {
    func addComponent(component: Component)
    func removeComponent(component: Component)
    
    func getComponents() -> [Component]
    
}