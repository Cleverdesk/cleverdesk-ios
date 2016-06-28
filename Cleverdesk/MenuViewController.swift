//
//  MenuViewController.swift
//  Cleverdesk
//
//  Created by Jonas Franz on 12.05.16.
//  Copyright © 2016 Cleverdesk. All rights reserved.
//

import UIKit
import JGProgressHUD

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var pages: UITableView!
    
    
    @IBAction func changeUser(sender: AnyObject) {
        //TODO Unsupported
    }
    
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        let hud = JGProgressHUD()
        hud.showInView(pages)
        loadData { (success) -> Void in
            print(success)
            hud.dismissAnimated(success)
            if !success {
                hud.indicatorView = JGProgressHUDErrorIndicatorView()
                hud.showInView(self.pages)
                hud.dismissAfterDelay(2.0, animated: true)
            }
            else{
                self.pages.reloadData()
            }
            
        }
        pages.delegate = self
        pages.dataSource = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    var pages_data: [String: String] = [:]
    
    
    func loadData(completion: (success: Bool) -> Void){
        if active_user == nil {
            completion(success: false)
            return
        }
        let request = BackendResponse(server: active_user!.server!)
        do {
            try request.execute("pages") { (error) in
                if error != nil  && (request.status_code?.isSuccess)!{
                    completion(success: false)
                    return
                }
                self.pages_data = request.body as! [String: String]
                
                completion(success: true)
            }
        }catch {
            completion(success: false)
        }
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! MenuCell
        
        (self.parentViewController as! DrawerViewController).setDrawerState(.Closed, animated: true)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let center  = (self.parentViewController as! DrawerViewController).mainViewController as! ViewController
             center.name = cell.title.text
             center.path = cell.path
            
        })
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(pages_data.count)
        return pages_data.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("listmenu", forIndexPath: indexPath) as! MenuCell
        cell.title?.text = Array(pages_data.keys)[indexPath.row]
        cell.path = pages_data[Array(pages_data.keys)[indexPath.row]]!
        
        return cell
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
