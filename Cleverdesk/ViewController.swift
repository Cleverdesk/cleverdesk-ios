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
                    //Request was not successfull. 
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
                var last :UIView?
                for view in request.toUI(){
                    view.frame = CGRectMake(0, pos + 8 - view.frame.height, self.scrollView.frame.width, view.frame.height)
                    pos += 8 + view.frame.height
                    view.translatesAutoresizingMaskIntoConstraints = false
                    self.scrollView.addSubview(view)
                    self.calculateConstraints(self.scrollView, target: view, above: last)
                    last = view
                }
            })
            
        }catch{
            print("Error while parsing page.")
        }
    }
    
    func calculateConstraints(root: UIScrollView, target: UIView, above: UIView?)  {
        /*let center = NSLayoutConstraint(item: target, attribute: .CenterX  , relatedBy: .Equal, toItem: root, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
        center.active = true
        let wi = root.frame.width - 16
        let width = NSLayoutConstraint(item: target, attribute: .Width  , relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: wi)
        width.active = true
        let height = NSLayoutConstraint(item: target, attribute: .Height  , relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: target.frame.height)
        height.active = true
        root.addConstraint(center)
        target.addConstraints([width, height])
        
        NSLayoutConstraint.activateConstraints([center, width, height])*/
        
        let horizontal = NSLayoutConstraint(item: target, attribute: .LeadingMargin, relatedBy: .Equal, toItem: root, attribute: .LeadingMargin, multiplier: 1.0, constant: 10)
        let horizontal2 = NSLayoutConstraint(item: target, attribute: .TrailingMargin, relatedBy: .Equal, toItem: root, attribute: .TrailingMargin, multiplier: 1.0, constant: -10)
        let horizontal3 = NSLayoutConstraint(item: target, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: root.frame.width - 20)
        var pinTop: NSLayoutConstraint?
        if above != nil {
             pinTop = NSLayoutConstraint(item: target, attribute: .Top, relatedBy: .Equal, toItem: above!, attribute: .Top, multiplier: 1.0, constant: above!.frame.height + 10)
            
        }else{
            
             pinTop = NSLayoutConstraint(item: target, attribute: .Top, relatedBy: .Equal, toItem: root, attribute: .Top, multiplier: 1.0, constant: 0)
        }
        
        NSLayoutConstraint.activateConstraints([horizontal, horizontal2, horizontal3, pinTop!])
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

