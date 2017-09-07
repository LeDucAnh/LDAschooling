//
//  ESPersonalViewController.swift
//  EnglishSociety
//
//  Created by Mac on 10/26/16.
//  Copyright © 2016 LeDucAnh. All rights reserved.
//



import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
//import GoogleMobileAds
//import FBSDKShareKit
import FirebaseAuth
import Firebase
//import SDWebImage
//import Pods_HSUFreeWalkingtour


class ESPersonalViewController: UIViewController,DPAResourceDetailStretchyHeaderViewDelegate,UITableViewDelegate,UITableViewDataSource {
    
      // var meaningVC =  MeaningTableViewController()
    @IBOutlet weak var ESPersonalBackgroundImageView: UIImageView!

    @IBOutlet weak var ESPersonalBackgroundBlurView: UIVisualEffectView!
    @IBOutlet weak var ESPersonalFacebookLoginButton: UIButton!
   // @IBOutlet weak var ESPersonalVCUsernameLabel: UILabel!
    
    @IBOutlet weak var ESPersonalOptionTableView: UITableView!
 //   @IBOutlet weak var ESPersonlVCUserImageView: UIImageView!
    var HSUControlStretchyHeaderView : DPAResourceDetailStretchyHeaderView?
    override func viewWillDisappear(_ animated: Bool) {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        self.tabBarController?.tabBar.barTintColor = UIColor.white

    }
    override func viewDidAppear(_ animated: Bool) {
        self.HSUControlStretchyHeaderView?.setRingOnImageView()
        
        
        /*
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "startVC")
        self.present(controller, animated: true, completion: nil)
        
        */
        

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        if indexPath.row == 0
        {
            self.handleRoleRegistration()
        }
        if indexPath.row == 1
        {
            if  FirebaseAuthAPI.shareInstance.currentLDACAUSer != nil
            {
                
                self.performSegue(withIdentifier: "toChatVC", sender: nil)
                
            }

            
        }
        if indexPath.row == 2
        {
            if  FirebaseAuthAPI.shareInstance.currentLDACAUSer != nil
            {
                let userVC = LDACAUserProfileViewController()
                self.present(userVC, animated: true, completion: nil)

                
            }
            
            
        }
        

        // self.performSegue(withIdentifier: "toTopic", sender: nil)
        
        /*
         FirebaseAPI.shareInstance.CheckifSigninOrnot({(DidSignIn)in
         
         
         })
         */
        
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UITableViewCell
        
        cell.backgroundColor = UIColor.white
        

        cell.textLabel?.textColor = UIColor(red: 105, green: 125, blue: 140)
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        cell.backgroundView?.layer.cornerRadius = 10.0
        cell.backgroundView?.layer.masksToBounds = false
        cell.backgroundView?.backgroundColor = UIColor.white
        
        
        if indexPath.row == 0
        {
            cell.textLabel?.text = "Register Role"
        
        }
        if indexPath.row == 1
        {
            
            if  FirebaseAuthAPI.shareInstance.currentLDACAUSer != nil
            {
                
                cell.textLabel?.text = "Chat"
                

            }
            else
            {
                cell.textLabel?.text = "Please register a Role to Chat"
                cell.backgroundColor = UIColor(red: 210, green: 110, blue: 100)
                
                
                
                cell.textLabel?.textColor = UIColor.white

            }

        }
        if indexPath.row == 2
        {
            if  FirebaseAuthAPI.shareInstance.currentLDACAUSer != nil
            {
                
                cell.textLabel?.text = "Role Page"
                
                
            }
            else
            {
                cell.textLabel?.text = "Please register a Role to continue"
                cell.backgroundColor = UIColor(red: 210, green: 110, blue: 100)
                
                
                
                cell.textLabel?.textColor = UIColor.white
                
            }

        }
return cell
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
        ESPersonalBackgroundImageView.isHidden = true
       // self.meaningVC.tableView.delegate =  self
        ESPersonalOptionTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.ESPersonalOptionTableView.delegate = self
        self.ESPersonalOptionTableView.dataSource = self
        
        self.configurateRegistrationTableview()
        // 1
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            // 2
            if user != nil {
                // 3
               // self.performSegue(withIdentifier: self.loginToList, sender: nil)
                
                    
                    self.handleSuccessfulLogin((user?.uid)!)
                    
            }
        }

        
        let loginManager = FBSDKLoginManager()
  
        
        
        let array = Bundle.main.loadNibNamed("DPAResourceDetailStretchyHeaderView", owner: self, options: nil)
        self.HSUControlStretchyHeaderView = array?.first as! DPAResourceDetailStretchyHeaderView
        self.ESPersonalOptionTableView.addSubview(self.HSUControlStretchyHeaderView!)

                                self.HSUControlStretchyHeaderView?.delegate =  self
        
            self.ESPersonalOptionTableView.backgroundColor = UIColor.clear
        self.view.backgroundColor = UIColor.clear
        //self.ESPersonalBackgroundBlurView.layer.zPosition = -1
       // self.ESPersonalBackgroundImageView.layer.zPosition = -2
    self.view.sendSubview(toBack: self.self.ESPersonalBackgroundBlurView)
    self.view.sendSubview(toBack: self.self.self.ESPersonalBackgroundImageView)
        
        /*self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
         self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
         self.navigationController.navigationBar.translucent = NO;*/
        self.setupNotification()
        
     }
    func didReceiveCurrentLDACAUser(notification: Notification)
    {
        
        
        ESPersonalOptionTableView.reloadData()
    }
    func setupNotification()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(ESPersonalViewController.didReceiveCurrentLDACAUser(notification:)), name: Notification.Name("notididreceivecurrentLDACAUSer"), object: nil)
    }
    func showStudentDialog(animated: Bool = true) {
        
        // Prepare the popup assets
        let title = "Successfully Authenticated"
        let message = "Congratulation , Now you can fully access your profile"
     
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: self.HSUControlStretchyHeaderView?.HSUFWTUserProfileImageview.image)
        
        
        // Create third button
        let okButton = DefaultButton(title: "Thanks") {
        }
        
        // Add buttons to dialog
        popup.addButtons([okButton])
        
        // Present dialog
        self.present(popup, animated: animated, completion: nil)
    }
    func showTeacherSignupDialog(animated: Bool = true)
    {
        // Prepare the popup assets
        let title = "Successfully Authenticated"
        let message = "Congratulation , Now you are a teacher , you can create and manage class or communicate to student or their parent"
        
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: self.HSUControlStretchyHeaderView?.HSUFWTUserProfileImageview.image)
        
        
        // Create third button
        let okButton = DefaultButton(title: "Thanks") {
        }
        
        // Add buttons to dialog
        popup.addButtons([okButton])
        
        // Present dialog
        self.present(popup, animated: animated, completion: nil)
    }
    var selectedUser: LDACAUser?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toChatVC" {
            //let vc = segue.destination as! ConversationsVC
            //vc.selectedUser = FirebaseAuthAPI.shareInstance.currentLDACAUSer
        }
    }

    func EscortButtonDidTouch() {
        
        
        return
        let optionAlert = SCLAlertView()
        optionAlert.addButton("Chat ")
        {
            
            //self.selectedUser =
            
         //   FirebaseLDACAUserAPI.shareInstance.getUserWithID("2131540", role: .student, completion: { (LDACAUsers) in
                
             //   self.selectedUser = LDACAUsers.first
            
            if  FirebaseAuthAPI.shareInstance.currentUser != nil
            {
            
                self.performSegue(withIdentifier: "toChatVC", sender: nil)
            }
           // })
        }
        
        optionAlert.addButton("Up date Profile Image ")
        {
            
            //self.selectedUser =
            
            //   FirebaseLDACAUserAPI.shareInstance.getUserWithID("2131540", role: .student, completion: { (LDACAUsers) in
            
            //   self.selectedUser = LDACAUsers.first
            
            let userVC = LDACAUserProfileViewController()
            self.present(userVC, animated: true, completion: nil)
            
            
            
           // self.performSegue(withIdentifier: "toChatVC", sender: nil)
            
            // })
        }

        optionAlert.addButton("I'm Teacher") {
        }
        
        
        
        
        optionAlert.addButton("I'm Student") {
                    let studentResAlert = SCLAlertView()
                let studentid = studentResAlert.addTextField()
            studentid.placeholder = "Your Student ID"
                let privatekey = studentResAlert.addTextField()
            privatekey.placeholder = "Your Private Key"
            studentResAlert.addButton("Register", action: { 
                
                
                
                FirebaseLDACAUserAPI.shareInstance.registerUserWithRoleID(roleID: studentid.text!, privateKey: privatekey.text!, completion: { (Bool) in
                    
                    
                    
                    if Bool
                    {
                        self.showStudentDialog()
                    }
                    else
                    {
                        let resultAlert = SCLAlertView()
                        optionAlert.addButton("OK") {
                            
                        }
                        resultAlert.showTitle("Fail", subTitle: "Fail to Register your Profile , please try again or contact our team for help. ", style: SCLAlertViewStyle.error)

                    }
                    
                })
                
                
            })
            studentResAlert.addButton("Exit ", action: {
                
            })
            
            studentResAlert.showTitle("Info Request", subTitle: "Enter your Info", style: SCLAlertViewStyle.info)
            
            
        }
        optionAlert.showTitle("Register", subTitle: "Who you are", style: .edit)
        return
        
        /*
        let alert = SCLAlertView()
        let Info = alert.addTextField("Tell us about you")
        let Number = alert.addTextField("Your Phone number")
        
        alert.addButton("Submit") {
            print("Text value: \(Info.text)")
            print("Text value: \(Number.text)")
           if let userid =  FIRAuth.auth()?.currentUser?.uid
           {
            FirebaseAuthAPI.shareInstance.updateUserEscortRegistration(Info.text!, phonenumber: Number.text!, uidString: userid, completion: { (Bool) in
                
                let alert = SCLAlertView()
                alert.showSuccess("Successfully Registered", subTitle: "We will contact to you shortly ,Meanwhile You can update your Info by resubmit a new form ")
                
                
                })
            }
            
        }
        alert.showEdit("Escort Registration", subTitle: "Your Information",closeButtonTitle: "Exit" )

        
        print("Start Escort")
 */
       // self.delegate?.EscortButtonDidTouch()
    }
    
    func handleRoleRegistration()
    {
    let roleAlert = SCLAlertView()
    let studentid = roleAlert.addTextField()
    studentid.placeholder = "Your Role ID"
    let privatekey = roleAlert.addTextField()
    privatekey.placeholder = "Your Private Key"
    
    
    
    
    roleAlert.addButton("Register", action: {
        FirebaseLDACAUserAPI.shareInstance.registerUserWithRoleID(roleID: studentid.text!, privateKey: privatekey.text!, completion: { (Bool) in
            
            if Bool
            {
                self.showTeacherSignupDialog()
            }
            else
            {
                let resultAlert = SCLAlertView()
                resultAlert.showTitle("Fail", subTitle: "Fail to Register your Profile , please try again or contact our team for help. ", style: SCLAlertViewStyle.error)
                
            }
            
        })
        
        
        
        
    })
    
    roleAlert.showTitle("Info Request", subTitle: "Enter your Info", style: SCLAlertViewStyle.info)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func performLoginAction(_ completion:@escaping (_ DidSignIn:Bool,_ uid:String)->Void)
    {
        
        
        let loginManager = FBSDKLoginManager()
        
            loginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self) { (FBSDKLoginManagerLoginResult, Error) in
                
                if(Error == nil){
                    print("No Error")
                    if (FBSDKLoginManagerLoginResult?.grantedPermissions.contains("email"))!
                    {
                        
                        self.GetFacebookUserProfile({ (result) in
                            
                            let userFBInfoDict = result 
                            

                            FirebaseAuthAPI.shareInstance.performLoginAction(userFBInfoDict, completion: { (IsSuccessful,uid) in
                                
                                if IsSuccessful
                                {
                                    completion(true,uid)
                                }
                                else
                                {
                                    completion(false,"")
                                }
                            })
                            
                    
                        })
                    }
                    else
                    {
                        completion(false,"")

                    }
                    
                    
                }else
                {
                    
                    completion(false,"")

                }
                
            }
        

    }
    //tableview Delegate + Datasource
    @IBAction func facebookLoginbutonDidtouch(_ sender: AnyObject) {
        let loginManager = FBSDKLoginManager()
        

        loginManager.logOut()
       
            //self.ESPersonalFacebookLoginButton.titleLabel?.text = "Login"
            self.ESPersonalFacebookLoginButton.setTitle("LOGIN", for: .normal)
            do
            {
                try  FIRAuth.auth()?.signOut()
                self.HSUControlStretchyHeaderView?.HSUFWTUserProfileImageview.image = UIImage()
                self.HSUControlStretchyHeaderView?.HSUFWTUserNameLabel.text = "Please Login"
                self.dismiss(animated: true , completion: nil)
            }
            catch
            {
                
            }
            // self.ESPersonalFacebookLoginButton.layer.masksToBounds =  true
        

        return
       // let loginManager = FBSDKLoginManager()
    
        if (FBSDKAccessToken .current() == nil)
        
            
        {
            
            let alertView = SCLAlertView()
            
            alertView.addButton("OK") {
                
            }
            alertView.appearance.showCloseButton = false
            alertView.showTitle("Signing in", subTitle:"Please Wait", style: .wait)
            

            self.performLoginAction({ (Bool,uid) in
                
                //success
                //             
                if Bool
                {
                    alertView.hideView()
                self.handleSuccessfulLogin(uid)
                }

            })
            /*
             
             
             */

            /*
        loginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self) { (FBSDKLoginManagerLoginResult, Error) in
            
            if(Error == nil){
                print("No Error")
                if (FBSDKLoginManagerLoginResult?.grantedPermissions.contains("email"))!
                {
                    
                    self.GetFacebookUserProfile()
                    // Do work
                }

                
             
            }

             }*/
        }
        else
        {
            loginManager.logOut()
            if (FBSDKAccessToken .current() == nil)
            {
                    //self.ESPersonalFacebookLoginButton.titleLabel?.text = "Login"
                self.ESPersonalFacebookLoginButton.setTitle("LOGIN", for: .normal)
             do
             {
               try  FIRAuth.auth()?.signOut()
                self.HSUControlStretchyHeaderView?.HSUFWTUserProfileImageview.image = UIImage()
                self.HSUControlStretchyHeaderView?.HSUFWTUserNameLabel.text = "Please Login"
                self.dismiss(animated: true , completion: nil)
                }
                catch
                {
                    
                }
               // self.ESPersonalFacebookLoginButton.layer.masksToBounds =  true
            }
            
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        
      //  if ExpandingCellIndex.contains(indexPath.row)
       // {
        //    return 150
        //}
        
        
        return 80
    }

    func GetFacebookUserProfile(_ completion:@escaping (_ userFBDict:NSDictionary)->Void)
    {
        if (FBSDKAccessToken .current() != nil)
        {
            let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"])
            graphRequest.start(completionHandler: { (connection, result, error) -> Void in
                if ((error) != nil)
                {
                    // Process error
                    print("Error: \(error)")
                  //  completion(nil)
                    
                }
                else
                {
                        let userFBInfoDict = result as! NSDictionary
                     completion(userFBInfoDict)
                }
                
            })
        }
        
        
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete
        {
                //    let tour  =  HSUFreeWalkingTourVariableModel.shareInstance.currentUserRegistrationTours?[indexPath.row]
            
            
        }
    }
    func configurateRegistrationTableview()
    {
        //self.ESPersonalTourRegistrationTableView.allowsMultipleSelectionDuringEditing = false
        //self.ESPersonalTourRegistrationTableView.register(ExpandableTableViewCell.self, forCellReuseIdentifier: "Cell")
        //self.ESPersonalTourRegistrationTableView.register(UINib(nibName: "ExpandableTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
       // self.ESPersonalTourRegistrationTableView.dataSource =  self
       // self.ESPersonalTourRegistrationTableView.delegate =  self
        
        
        
        
    }
    func handleSuccessfulLogin(_ uidString:String)
    {
        

        
        let alertView = SCLAlertView()
        
        alertView.addButton("OK") {
            
        }
        alertView.appearance.showCloseButton = false
        alertView.showTitle("Good to Go", subTitle: "Successfully Perform a Login Action", style: .success)
        

    
        
        let ref  =  FIRDatabase.database().reference(fromURL: "https://contactapp-fd758.firebaseio.com")
        let usersRef  =  ref.child("Users").child(uidString)
        
        usersRef.observe(FIRDataEventType.value, with: { (snapshot) in
            
         if   let user = snapshot.value as? [String : Any]
            
            
         {
            
            //let picture =  EnglishSocietyConfigurateVaribles.SharedInstance.currentFbuser?.FbUserPicture
            
                         if user["EsContactNumb"] != nil && user["EscDescription"] != nil
             {
                if EsCortRegistrationState(rawValue: user["ESState"] as! Int)
                    == EsCortRegistrationState.userApproved
                {
                    
                    self.HSUControlStretchyHeaderView?.HSUFWTEscortRegistrationButton.setTitle("You are now An Escort", for: .normal)
                }
                
                if  EsCortRegistrationState(rawValue: user["ESState"] as! Int)
== EsCortRegistrationState.userDenied
                    {

                        self.HSUControlStretchyHeaderView?.HSUFWTEscortRegistrationButton.setTitle("You Are Denined", for: .normal)
                       // self.HSUControlStretchyHeaderView?.HSUFWTEscortRegistrationButton.titleLabel?.text   = "You Are Denined"
                }
                if  EsCortRegistrationState(rawValue: user["ESState"] as! Int)
                    == EsCortRegistrationState.userPending
                    {
                        //self.HSUControlStretchyHeaderView?.HSUFWTEscortRegistrationButton.titleLabel?.text   = "Pending..."
                        self.HSUControlStretchyHeaderView?.HSUFWTEscortRegistrationButton.setTitle("Pending...", for: .normal)
                    }
            }
            
            
            
            FirebaseAuthAPI.shareInstance.currentUser = User(snapshot: snapshot)
            if let pictureURL = user["profileImageURL"]  {

              self.HSUControlStretchyHeaderView?.HSUFWTUserProfileImageview.sd_setImage(with: URL(string: pictureURL as! String))
               // self.ESPersonalBackgroundImageView.image = self.HSUControlStretchyHeaderView?.HSUFWTUserProfileImageview.image
                self.ESPersonalBackgroundImageView.sd_setImage(with: URL(string: pictureURL as! String))

                self.HSUControlStretchyHeaderView?.DPAResourceDetailStretchyHeaderView_ResourceImageView.sd_setImage(with: NSURL(string: (pictureURL as! String)) as URL!)
                

            }
            if let name = user["name"]  {
                self.HSUControlStretchyHeaderView?.HSUFWTUserNameLabel.text =  name as! String
                if let studentid = user["StudentID"] {
                    self.HSUControlStretchyHeaderView?.HSUFWTUserNameLabel.text =  (name as! String) + (studentid as! String)
                }
                

               
                
            }
            
            self.ESPersonalFacebookLoginButton.setTitle("LOGOUT", for: .normal)
            


            

            

            
           // self.imageView.sd_setImage(with: URL(string: user["profileImageURL"] as! String))
            //self.PlayerNameLabel.text = user["name"] as! String
            //self.PlayerScoreLabel.text = "🏆 : " + String(user["highScore"] as! Int)
            //self.PlayerMoneyLabel.text = "💰 : " + String(user["money"] as! Int)
            // labelNode.text = "🛡\(lives)  🏆\(highScoreFormatted) 💰\(scoreFormatted)"
               // self.loadUserShip()
                
                //self.GameMenuItemTableVC.reloadData()
            }
            
        })
        
        
    }

}
