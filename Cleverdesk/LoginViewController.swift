import UIKit
import JGProgressHUD
import Async
import CoreData

class LoginViewController: UIViewController {

    @IBOutlet weak var server: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (UIApplication.sharedApplication().delegate as! AppDelegate).active_user == nil {
            self.performSegueWithIdentifier("goToMain", sender: nil)
        }
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "banner4")!)

        // Do any additional setup after loading the view.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
}

extension UITextField{
    func validate() -> Bool{
        return self.text == nil || self.text == ""
        
        
    }
}
