//
//  BackendResponse.swift
//  Cleverdesk
//
//  Created by Jonas Franz on 15.05.16.
//  Copyright © 2016 Cleverdesk. All rights reserved.
//

import Foundation
import UIKit
import Async

class BackendResponse {
    var base_url: String = "http://Matthiass-MBP.local:8080/"
    var body: AnyObject?
    var status_code: HTTPStatusCode?
    
    init  () {
        
    }
    
    init (server: Server){
        base_url = server.url!
    }

    internal var error: NSError?
    
    func execute(path: String) throws  {
        print("\(base_url)\(path)")
        let data: NSData =  NSData(contentsOfURL: NSURL(string: "\(base_url)\(path)")!)!
        var json: [String: AnyObject] =  try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! [String: AnyObject]
        status_code = HTTPStatusCode(rawValue: (json["status"] as? Int)!)

        body = json["body"]
    }
    
    func execute(path: String, completionHandler: (error: NSError?) -> Void) throws  {
        print("\(base_url)\(path)")
        
        let url = NSURL(string: "\(base_url)\(path)")!
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.setValue((UIApplication.sharedApplication().delegate as! AppDelegate).active_user?.token, forHTTPHeaderField: "token")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
       
        let task =  NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data, response, error) in
            if error != nil {
                self.error = error
                completionHandler(error: error)
                return
            }
            do {
                
                var json: [String: AnyObject] = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! [String: AnyObject]
                self.status_code = HTTPStatusCode(rawValue: (json["status"] as? Int)!)
                print(json)
                self.body = json["body"]
            }catch{
                self.error = error as NSError
                
                
            }
            Async.main(){
                completionHandler(error: self.error)
            }
            
        }
        
        task.resume()
        
        
        
    }

    
    
    func execute(path: String, post_body: [String: AnyObject], completionHandler: (error: NSError?) -> Void) throws  {
        print("\(base_url)\(path)")
    
        let jsonData = try NSJSONSerialization.dataWithJSONObject(post_body, options: .PrettyPrinted)
        let url = NSURL(string: "\(base_url)\(path)")!
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = jsonData
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        print(NSString(data: request.HTTPBody!, encoding: NSASCIIStringEncoding))
        
        let task =  NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data, response, error) in
            if error != nil {
                self.error = error
                completionHandler(error: error)
                return
            }
            do {
                
                var json: [String: AnyObject] = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! [String: AnyObject]
                self.status_code = HTTPStatusCode(rawValue: (json["status"] as? Int)!)
                print(json)
                self.body = json["body"]
            }catch{
                self.error = error as NSError
                
                
            }
            completionHandler(error: self.error)
            
        }
        
        task.resume()
        
        
        
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