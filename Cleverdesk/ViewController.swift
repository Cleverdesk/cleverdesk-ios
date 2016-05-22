//
//  ViewController.swift
//  Cleverdesk
//
//  Created by Jonas Franz on 12.05.16.
//  Copyright © 2016 Cleverdesk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var leftSliderBtn: UIBarButtonItem!
    
    @IBAction func openDrawer(sender: UIBarButtonItem) {
        let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if app.centerDrawer.openSide == .None {
            
            app.centerDrawer.openDrawerSide(.Left, animated: true, completion: nil)
            
        }else{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                do{
                    let request = BackendResponse()
                    try request.execute("TestPlugin/HelloWorld")
                    dispatch_async(dispatch_get_main_queue(), {
                        self.scrollView.subviews.forEach({ (vi) in
                            vi.removeFromSuperview()
                        })
                        for view in request.toUI(){
                            self.scrollView.addSubview(view)
                        }
                    })
                   
                }catch{
                    print("Error while parsing page.")
                }
            })
            
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

