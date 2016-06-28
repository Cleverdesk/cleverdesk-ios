//
//  DrawerViewController.swift
//  Cleverdesk
//
//  Created by Jonas Franz on 25.06.16.
//  Copyright © 2016 Cleverdesk. All rights reserved.
//

import UIKit
import KYDrawerController

class DrawerViewController: KYDrawerController, KYDrawerControllerDelegate {

    @IBOutlet weak var burgerButton: UIBarButtonItem!
    
    private let open = UIImage(named: "ic_close_48pt")
    private let closed = UIImage(named: "ic_menu_48pt")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func drawerController(drawerController: KYDrawerController, stateChanged state: KYDrawerController.DrawerState) {
        if state == KYDrawerController.DrawerState.Closed {
            burgerButton.image = closed
        }else {
            burgerButton.image = open
        }
    }

    @IBAction func changeState(sender: UIBarButtonItem) {
        if sender.image == closed {
            setDrawerState(.Opened, animated: true)
            
        }else {
            
            setDrawerState(.Closed, animated: true)
        }
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
