import UIKit
import JGProgressHUD
import Async
import CoreData

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var server: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var textFieldTopConstr: NSLayoutConstraint!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (UIApplication.sharedApplication().delegate as! AppDelegate).active_user == nil {
            self.performSegueWithIdentifier("goToMain", sender: nil)
        }
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "banner4")!)
        self.logInButton.layer.cornerRadius = 5
        self.logInButton.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    
    func animateState(keyboardAppearing: Bool){
        switch UIDevice().type {
        case .iPhone4S, .iPhone4, .iPhone5, .iPhone5C, .iPhone5S, .simulator:
            break
        default:
            return
        }
        
        
        if keyboardAppearing{
           
            UIView.animateWithDuration(NSTimeInterval(0.3), animations: {
                self.logoImageView.alpha = 0.0
                }, completion: { (succ: Bool) in
                    if succ{
                        switch UIDevice().type{
                        case .iPhone4, .iPhone4S, .simulator:
                            self.textFieldTopConstr.constant = -100
                        default:
                            self.textFieldTopConstr.constant = -50
                        }
                        
                        UIView.animateWithDuration(NSTimeInterval(0.5), animations: {
                            self.view.layoutIfNeeded()
                        })
                    }
            })
            
        }
        else{
            self.textFieldTopConstr.constant = 30
            UIView.animateWithDuration(NSTimeInterval(0.6), animations: {
                self.view.layoutIfNeeded()
                }, completion: { (succ: Bool) in
                    if succ{
                        UIView.animateWithDuration(NSTimeInterval(0.6), animations: {
                            self.logoImageView.alpha = 1.0
                        })
                    }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func willLogin(sender: UIButton) {
        
        
        if server.validate() {
            alert("Error", message: "Please enter your server adress!")
            return
        }
        
        if !verifyUrl(server.text) {
            alert("Error", message: "Server-URL is invalid!")
            return
        }
        
        if username.validate(){
            alert("Error", message: "Please enter your username!")
            return
            
        }
        if password.validate(){
            alert("Error", message: "Please enter your password!")
            return
            
        }
        let hud = JGProgressHUD()
        hud.showInView(self.view)
        
        let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "User")
        let entityDescription = NSEntityDescription.entityForName("User", inManagedObjectContext: moc)
        fetchRequest.entity = entityDescription
        
        
        do {
            let result = try moc.executeFetchRequest(fetchRequest) as! [User]
            var newUser: User?
            for user in result {
                if user.username != nil && user.username == username.text{
                    if user.server != nil && user.server?.url != nil && user.server?.url == server.text {
                        newUser = user
                        break
                    }else{
                        user.active = false
                    }
                }else {
                    user.active = false
                }
            }
            
            if newUser == nil {
               newUser =  NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: moc) as? User
            }

            
            newUser!.username = username.text
            
            let sDescription = NSEntityDescription.entityForName("Server", inManagedObjectContext: moc)
            let sFetchReq = NSFetchRequest(entityName: "Server")
            sFetchReq.entity = sDescription
            
            let results = try moc.executeFetchRequest(sFetchReq) as! [Server]
            var usedServer: Server?
            for s in results {
                if s.url != nil && s.url == self.server.text {
                    usedServer = s
                    break
                }
            }
            if usedServer == nil {
                let req = BackendResponse()
                req.base_url = server.text!
                if !req.base_url.hasSuffix("/"){
                    req.base_url = req.base_url + "/"
                }
                try req.execute("")
                if !(req.status_code?.isSuccess)! {
                    alert("Error", message: (req.status_code?.localizedReasonPhrase)!)
                    Async.main(){
                        hud.dismiss()
                    }
                    return
                }
                usedServer = NSEntityDescription.insertNewObjectForEntityForName("Server", inManagedObjectContext: moc) as? Server
                usedServer?.url = req.base_url
                usedServer?.version = req.body as? String
            }
            
            let tokenRequest = BackendResponse(server: usedServer!)
            try tokenRequest.execute("auth", post_body: ["username": username.text!, "password": password.text! , "lifetime": 2 * 30 * 24 * 60 * 60] ) {
                (error) in
                if error != nil {
                    print(tokenRequest.body)
                    self.alert("Error", message: (error!.localizedDescription))
                    Async.main(){
                        hud.dismiss()
                    }
                    return
                }
                if !(tokenRequest.status_code?.isSuccess)! {
                    self.alert("Error", message: (tokenRequest.body as! String))
                    Async.main(){
                        hud.dismiss()
                    }
                    return
                }
                newUser!.token = tokenRequest.body as? String
                print(tokenRequest.body)
                newUser!.server = usedServer
                newUser!.active = true
                do {
                    try moc.save()
                    (UIApplication.sharedApplication().delegate as! AppDelegate).active_user = newUser
                    Async.main(){
                        hud.dismiss()
                        self.performSegueWithIdentifier("goToMain", sender: sender)
                    }

                }catch {
                    let fetchError = error as NSError
                    self.alert("Error", message: fetchError.localizedDescription)
                    print(fetchError)
                    Async.main(){
                        hud.dismiss()
                    }
                }
            }
          
            
            
            
        } catch {
            let fetchError = error as NSError
            alert("Error", message: fetchError.localizedDescription)
            print(fetchError)
            hud.dismiss()
        }
        
        
    
    }
    
    func verifyUrl (urlString: String?) -> Bool {
        //Check for nil
        if let urlString = urlString {
            // create NSURL instance
            if let url = NSURL(string: urlString) {
                // check if your application can open the NSURL instance
                return UIApplication.sharedApplication().canOpenURL(url)
            }
        }
        return false
    }
    
    func alert(title: String, message: String){
        Async.main(){
            let alertController = UIAlertController(title: title, message:
                message, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return false
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        animateState(true)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            username.becomeFirstResponder()
        case 1:
            password.becomeFirstResponder()
        case 2:
            password.resignFirstResponder()
            willLogin(UIButton())
        default:
            print("Error in switch")
        }
        return true
    }
    
    @IBAction func HideKeyboard(sender: UITapGestureRecognizer) {
        animateState(false)
        server.resignFirstResponder()
        username.resignFirstResponder()
        password.resignFirstResponder()
    }

    
    
}

extension UITextField{
    func validate() -> Bool{
        return self.text == nil || self.text == ""
        
        
    }
}
