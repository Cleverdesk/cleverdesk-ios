//
//  MenuViewController.swift
//  Cleverdesk
//
//  Created by Jonas Franz on 12.05.16.
//  Copyright © 2016 Cleverdesk. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var pages: UITableView!
    
    let menuDel = MenuTableDelegate()
    
    @IBAction func changeUser(sender: AnyObject) {
        //TODO Unsupported
    }
    
    
    
    override func viewDidLoad(){
        menuDel.loadData { (success) -> Void in
            print(success)
        }
        pages.delegate = menuDel
        pages.dataSource = menuDel
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
