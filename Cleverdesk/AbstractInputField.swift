//
//  AbstractInputField.swift
//  Cleverdesk
//
//  Created by Jonas Franz on 15.05.16.
//  Copyright © 2016 Cleverdesk. All rights reserved.
//

import Foundation
import UIKit

class AbstractInputField<T> {
    var input_name: String = ""
    var value: T?
    var placeholder: T?
    var label: String?
}