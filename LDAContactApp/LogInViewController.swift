//
//  ViewController.swift
//  LDAContactApp
//
//  Created by Mac on 4/5/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit
import ILLoginKit
import TKSubmitTransition
class LogInViewController: UIViewController {

    lazy var loginCoordinator: LoginCoordinator = {
        return LoginCoordinator(rootViewController: self)
    }()
    
    func showLogin() {
        loginCoordinator.start()
    }
    override func viewDidAppear(_ animated: Bool) {
//
        
        

FirebaseAPI.shareInstance.CheckifSigninOrnot { (Bool) in
        if !Bool{
        self.showLogin()
        }
    else
        {
            
            FirebaseAuthAPI.shareInstance.saveLDACAUserToFirebaseAuth(completion: { (User) in
                            FirebaseAuthAPI.shareInstance.setupFirebase()
            })
            

            self.performSegue(withIdentifier: "toUsingVC", sender: nil)
    }
        }
        
      //  let secondVC = ESPersonalViewController()
        // self.present(secondVC, animated: true, completion: nil)
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


class LoginCoordinator: ILLoginKit.LoginCoordinator {
    
    // MARK: - LoginCoordinator
    var viewcontrollerInstance:UIViewController?
    func start(withViewController:UIViewController) {
        super.start()
        configureAppearance()
        self.viewcontrollerInstance = withViewController
    }

    override func start() {
        super.start()
        configureAppearance()
    }
    
    override func finish() {
        super.finish()
    }
    
    // MARK: - Setup
    
    // Customize LoginKit. All properties have defaults, only set the ones you want.
    func configureAppearance() {
        // Customize the look with background & logo images
       // backgroundImage =
        // mainLogoImage =
        // secondaryLogoImage =
        
        // Change colors
        tintColor = UIColor(red: 52.0/255.0, green: 152.0/255.0, blue: 219.0/255.0, alpha: 1)
        errorTintColor = UIColor(red: 253.0/255.0, green: 227.0/255.0, blue: 167.0/255.0, alpha: 1)
        
        // Change placeholder & button texts, useful for different marketing style or language.
        loginButtonText = "Sign In"
        signupButtonText = "Create Account"
        facebookButtonText = "Login with Facebook"
        forgotPasswordButtonText = "Forgot password?"
        recoverPasswordButtonText = "Recover"
        namePlaceholder = "Name"
        emailPlaceholder = "E-Mail"
        passwordPlaceholder = "Password!"
        repeatPasswordPlaceholder = "Confirm password!"
    }
    
    // MARK: - Completion Callbacks
    
    // Handle login via your API
    override func login(email: String, password: String) {
        print("Login with: email =\(email) password = \(password)")
     FirebaseAuthAPI.shareInstance.loginWithEmail(email: email, password: password) { (user, uid, success,error) in
        
            if success
            {
                
                self.handleSuccessLogin()
                
                LDAActionResultHandler.sharedInstance.handleAction(title: "Successful Login")
                

            }
            else
            {
                
                LDAActionResultHandler.sharedInstance.handleAction(title: "Fail \(error)")
                
            }
        }
    }
    
    // Handle signup via your API
    override func signup(name: String, email: String, password: String) {
        print("Signup with: name = \(name) email =\(email) password = \(password)")
        
        var user  = User(password: password, email: email)
        user.name = name
        FirebaseAuthAPI.shareInstance.createUserWithEmail(LDACAuser: user) { (result, uid) in
            if result
            {
                let alertView = SCLAlertView()
                
                alertView.addButton("OK") {
                    
                }
                alertView.appearance.showCloseButton = false
                alertView.showTitle("SignUp Completed", subTitle:"Successfully created an account for you , please Login to use", style: .success)
                


                
            }
        }
        
    }
    
    // Handle Facebook login/signup via your API
    override func enterWithFacebook(profile: FacebookProfile) {
        print("Login/Signup via Facebook with: FB profile =\(profile)")

        let alertView = SCLAlertView()
        
        alertView.addButton("OK") {
            
        }
        alertView.appearance.showCloseButton = false
        alertView.showTitle("Signing in", subTitle:"Please Wait", style: .wait)

        self.performFirebaseFacebookLoginAction { (boolResult, uid) in
            
            alertView.hideView()
            if boolResult
            {
               
                self.set()
                
                self.handleSuccessLogin()
                

            }
        }
        
    }
    
    func handleSuccessLogin()
    {
        
        
        
        (self.initialViewController.facebookButton as! TKTransitionSubmitButton).startFinishAnimation(2) {
            //Your Transition
            
            
            
            //  self.viewcontrollerInstance?.performSegue(withIdentifier: "toUsingVC", sender: nil)
            
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.2) {
            
            
            self.finish()
        }

    }
    
    // Handle password recovery via your API
    override func recoverPassword(email: String) {
        print("Recover password with: email =\(email)")
    }
    
    //Firebase
    

    func performFirebaseFacebookLoginAction(_ completion:@escaping (_ DidSignIn:Bool,_ uid:String)->Void)
    {
        (self.initialViewController.facebookButton as! TKTransitionSubmitButton).startLoadingAnimation()
        
        FacebookSharedFunctions.sharedInstance.GetFacebookUserProfile { (userFBInfoDict) in
            
               FirebaseAuthAPI.shareInstance.currentUser  = User(FbDict: userFBInfoDict)
            FirebaseAuthAPI.shareInstance.performLoginAction(userFBInfoDict, completion: { (IsSuccessful,uid) in
                
                if IsSuccessful
                {
                    
                   // (self.initialViewController.facebookButton as! TKTransitionSubmitButton).startFinishAnimation(2) {
                     //Your Transition
                        

                        
                    
                        completion(true,uid)

//                     }
                    


                }
                else
                {
                    completion(false,"")
                }
            })
            
        }
        

        
    }
}

