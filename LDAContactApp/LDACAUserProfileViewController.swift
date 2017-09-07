//
//  LDACAUserProfileViewController.swift
//  LDAContactApp
//
//  Created by Mac on 6/1/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit

class LDACAUserProfileViewController: UIViewController {
    @IBOutlet weak var LDACAProfilePasswordTextField: UITextField!


    @IBOutlet weak var LDACAUserProfileImageView: UIImageView!
    @IBOutlet weak var LDACAUserNameLabel: UILabel!
    var navView = LDACANavView()
    
    func setupRole()
    {
        print(FirebaseAuthAPI.shareInstance.currentLDACAUSer)
        if FirebaseAuthAPI.shareInstance.currentLDACAUSer != nil
        {
            
            if FirebaseAuthAPI.shareInstance.currentLDACAUSer?.role == UserRole.student.rawValue
            {
                LDACAUserNameLabel.text = (FirebaseAuthAPI.shareInstance.currentLDACAUSer?.lastName)! + "-Student"            }
            if FirebaseAuthAPI.shareInstance.currentLDACAUSer?.role == UserRole.teacher.rawValue
            {
                    LDACAUserNameLabel.text = (FirebaseAuthAPI.shareInstance.currentLDACAUSer?.lastName)! + "-Teacher"
            }
            if FirebaseAuthAPI.shareInstance.currentLDACAUSer?.role == UserRole.staff.rawValue
            {
               LDACAUserNameLabel.text =  (FirebaseAuthAPI.shareInstance.currentLDACAUSer?.lastName)! + "-Staff"
            }
            
            
        }
        else{
        LDACAUserNameLabel.text =  (FirebaseAuthAPI.shareInstance.currentLDACAUSer?.lastName)! + "No role"
        }
    }

    @IBAction func passwordUpdateDidTouch(_ sender: Any) {
        
        
        
        FirebaseLDACAUserAPI.shareInstance.updateUserPassWord(password: LDACAProfilePasswordTextField.text!) { (Bool) in
            
            if Bool
            {
                LDAActionResultHandler.sharedInstance.handleAction(title: "Successfully update Password")
            }
            else
            {
                
                LDAActionResultHandler.sharedInstance.handleAction(title: "Fail to update Password")
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if let image  = FirebaseAuthAPI.shareInstance.currentLDACAUSer?.profileimage as? UIImage
        {
            
            self.LDACAUserProfileImageView.image = image
        }
        else
        {
            self.LDACAUserProfileImageView.sd_setImage(with: URL(string: (FirebaseAuthAPI.shareInstance.currentLDACAUSer?.profileImageURL)!)) { (UIImage, Error, SDImageCacheType, URL) in
                
                FirebaseAuthAPI.shareInstance.currentLDACAUSer?.profileimage = UIImage
            }
        }

        self.setupRole()
        
        
        self.LDACAProfilePasswordTextField.text = FirebaseAuthAPI.shareInstance.currentLDACAUSer?.password
        ESAnimation.shareInstance.executeGradientBorderAnimationFor(view: self.LDACAUserProfileImageView, colors: [UIColor.yellow.cgColor,UIColor.red.cgColor,UIColor.orange.cgColor])
        ESAnimation.shareInstance.shakeView(self.LDACAUserProfileImageView, updown: 2, leftright: 0.4)
    
    


    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.LDACAUserProfileImageView.backgroundColor = UIColor.green
          self.LDACAUserProfileImageView.layer.cornerRadius = LDACAUserProfileImageView.frame.size.width/2
         self.LDACAUserProfileImageView.layer.masksToBounds = true
        
        
        

        //self.LDACAUserProfileImageView.sd_setImage(with: )
        
        self.setupViewLayout()
        // Do any additional setup after loading the view.
        setupProfileImage()

    }
    func setupProfileImage()
    {
        LDACAUserProfileImageView.image = UIImage(named: "user")
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped(tapGestureRecognizer:)))
        LDACAUserProfileImageView.isUserInteractionEnabled = true
        LDACAUserProfileImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    func profileImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        
        
        // Your action
        
        let updateImagevc = LDACAUploadImageViewController()
        self.present(updateImagevc, animated: true, completion: nil)

        
    }

    func setupViewLayout()
    {
        
        
        self.navView.embedToView(view: self.view)
        self.navView.DoneButton.setTitle("", for: .normal)
        
        self.navView.backgroundColor = UIColor.rbg(r: 45, g: 135, b: 220)
        
        
        self.navView.registerForReturnAction { (LDACANavViewReturnAction) in
            print("nav view action")
            if LDACANavViewReturnAction == .exit
                
            {
                self.dismiss(animated: true, completion: nil)
            }
            
            
            

        }
        
        self.LDACAUserProfileImageView.anchor(self.navView.bottomAnchor, left: nil, bottom: LDACAUserNameLabel.topAnchor, right: nil, topConstant: 8, leftConstant: 0, bottomConstant: 4, rightConstant: 0, widthConstant: 80, heightConstant: 80)
    //    self.view.addSubview(self.videoView)
        
    //    self.videoView.anchor(self.navView.bottomAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
