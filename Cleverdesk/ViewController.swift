//
//  ViewController.swift
//  Cleverdesk
//
//  Created by Jonas Franz on 12.05.16.
//  Copyright © 2016 Cleverdesk. All rights reserved.
//

import UIKit
import JGProgressHUD

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var leftSliderBtn: UIBarButtonItem!
    
    var path: String {
        get{
            return path_copy
        }
        set(value){
            path_copy = value
            openPage()
        }
    }
    
    private var path_copy: String = "Main/Home"
    
    
    
    var name: String? {
        get {
            return self.navigationItem.title
        }
        set(value) {
            self.title = value
        }
    }
    
   
    
    var hud: JGProgressHUD?
    
    
    var components: [UITableViewCell] = []
    
    
    
    func openPage(){
        
        do{
            let request = BackendResponse()
            
            let root = view
            dispatch_async(dispatch_get_main_queue(), {
                self.hud = JGProgressHUD(style: .Light)
                self.hud!.indicatorView = JGProgressHUDIndeterminateIndicatorView(HUDStyle: .Light)
                self.hud!.showInView(self.tableView)
            })
            try request.execute(path) {
                (error) in
                self.components.removeAll()
                self.hud!.dismiss()
                if error != nil {
                    self.hud!.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud!.showInView(self.tableView)
                    self.hud!.dismissAfterDelay(4.0, animated: true)
                    print(error)
                    
                    return
                }
                if !(request.status_code?.isSuccess)!{
                    //Request was not successfull.
                    self.hud = JGProgressHUD(style: .Light)
                    self.hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud!.textLabel.text = request.status_code?.localizedReasonPhrase.uppercaseString
                    self.hud!.showInView(root)
                    self.hud!.dismissAfterDelay(4.0, animated: true)
                
                    return
                }
                for cell in request.toUI() {
                    if !(cell is UITableViewCell){
                        let container_cell = UITableViewCell()
                        container_cell.frame = cell.frame
                        cell.frame = (container_cell.textLabel?.frame)!
                        container_cell.addSubview(cell)
                        self.components.append(container_cell)
                    }else {
                        self.components.append(cell as! UITableViewCell)
                    }
                }
                
                self.tableView.reloadData()
                

            }
            
           
            
            dispatch_async(dispatch_get_main_queue(), {
            
            })
            
        }catch{
            print("Error while parsing page.")
        }
    }
    
    
    override func viewDidLoad() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(components.count)
        return components.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return components[indexPath.row]
    }
    

}

