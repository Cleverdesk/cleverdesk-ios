//
//  ViewController.swift
//  Cleverdesk
//
//  Created by Jonas Franz on 12.05.16.
//  Copyright © 2016 Cleverdesk. All rights reserved.
//

import UIKit
import JGProgressHUD

class ViewController: UIViewController {
    
    @IBOutlet weak var page: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var leftSliderBtn: UIBarButtonItem!
    
    @IBAction func openDrawer(sender: UIBarButtonItem) {
        let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if app.centerDrawer.openSide == .None {
            
            app.centerDrawer.openDrawerSide(.Left, animated: true, completion: nil)
            
        }else{
            app.centerDrawer.closeDrawerAnimated(true, completion: nil)
            
        }
        
        
    }
    
    var hud: JGProgressHUD?
    
    func openPage(path: String, name: String){
        
        do{
            
            let request = BackendResponse()
            
            let root = view
            dispatch_async(dispatch_get_main_queue(), {
                self.title = name
                self.page.text = name
                self.hud = JGProgressHUD(style: .Light)
                self.hud!.indicatorView = JGProgressHUDIndeterminateIndicatorView(HUDStyle: .Light)
                self.hud!.showInView(root)
            })
            try request.execute(path)
            
           
            
            dispatch_async(dispatch_get_main_queue(), {
                self.hud!.dismiss()
                if !(request.status_code?.isSuccess)!{
                    self.hud = JGProgressHUD(style: .Light)
                    self.hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud!.textLabel.text = request.status_code?.localizedReasonPhrase.uppercaseString
                    self.hud!.showInView(root)
                    self.hud!.dismissAfterDelay(3.0, animated: true)
                    return
                }
                
                self.scrollView.subviews.forEach({ (vi) in
                    vi.removeFromSuperview()
                })
                var pos:CGFloat = -8;
                for view in request.toUI(){
                    view.frame = CGRectMake(0, pos + 8 - view.frame.height, self.scrollView.frame.width, view.frame.height)
                    pos += 8 + view.frame.height
                    print(view)
                    self.scrollView.addSubview(view)
                }
            })
            
        }catch{
            print("Error while parsing page.")
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
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }


}

