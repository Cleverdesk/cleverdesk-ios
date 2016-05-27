//
//  BackendResponse.swift
//  Cleverdesk
//
//  Created by Jonas Franz on 15.05.16.
//  Copyright © 2016 Cleverdesk. All rights reserved.
//

import Foundation
import UIKit

class BackendResponse {
    var base_url: String = "http://Jonass-iMac.local:8080/"
    var body: AnyObject?
    var status_code: HTTPStatusCode?

    
    func execute(path: String) throws  {
        print("\(base_url)\(path)")
        let data: NSData =  NSData(contentsOfURL: NSURL(string: "\(base_url)\(path)")!)!
        var json: [String: AnyObject] =  try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! [String: AnyObject]
        status_code = HTTPStatusCode(rawValue: (json["status"] as? Int)!)

        body = json["body"]
    }
    
    func toUI() -> [UIView] {
        if body == nil {
            return [UIView]()
        }
        let ui = UI()
        ui.fromJSON(body!)
        return ui.toUI(CGRectMake(8, 0, 200, 20))!
    }
    
    
    
}