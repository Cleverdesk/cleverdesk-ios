//
//  MenuTableDelegate.swift
//  Cleverdesk
//
//  Created by Jonas Franz on 14.05.16.
//  Copyright © 2016 Cleverdesk. All rights reserved.
//

import UIKit

class MenuTableDelegate: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var pages: [String: String] = [:]
    
    
    func loadData(completion: (success: Bool) -> Void){
        let data = NSData(contentsOfURL: NSURL(string: "http://Matthiass-MBP.local:8080/pages")!)
        do{
            if data == nil {
                completion(success: false)
                return
            }
            let dir: [String: AnyObject]? = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? [String: AnyObject]
            if dir != nil{
                pages =  dir!["body"] as! [String: String]
                completion(success: true)
            }
            completion(success: false)
        }catch{
            completion(success: false)
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! MenuCell
        (UIApplication.sharedApplication().delegate as! AppDelegate).centerDrawer.closeDrawerAnimated(true, completion: nil)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let center  = (UIApplication.sharedApplication().delegate as! AppDelegate).center!
            center.name = cell.title.text
            center.path = cell.path
            
        })
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pages.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("listmenu", forIndexPath: indexPath) as! MenuCell
        cell.title?.text = Array(pages.keys)[indexPath.row]
        cell.path = pages[Array(pages.keys)[indexPath.row]]!
        
        return cell
    }
    
    
}
