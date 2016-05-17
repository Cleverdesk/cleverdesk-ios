//
//  Component.swift
//  Cleverdesk
//
//  Created by Jonas Franz on 15.05.16.
//  Copyright © 2016 Cleverdesk. All rights reserved.
//

import Foundation
import UIKit

protocol Component {
    func name() -> String
    func toUI(frame: CGRect) -> [UIView]?
    func fromJSON(json: AnyObject)
    func copy() -> Component
    

}

