//
//  LDACAPostNotificationViewController.swift
//  LDAContactApp
//
//  Created by Mac on 5/18/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit
import URLEmbeddedView
import FDTake
/*
class LDACATextView:UITextView ,UITextViewDelegate
{
    init() {
        super.init(frame: CGRect.zero)
    }
    func setup()
    {
        self.delegate  =  self
    }
    var placeHolder : String
    func textViewDidChange(_ textView: UITextView) {
        
    }
}
 */
class LDACAPostNotificationViewController: UIViewController , UITextViewDelegate {

 //   var inputTextview = UITextView()
    var viewerIDStringArr : [Int]!
    {
        didSet {
            print(self)
            self.initAllSelectedID()
        }
    }
    
    
    var videoView: ESVideoView!
    
    var videoButton = UIButton()
    var imageView = UIImageView()
      var imageViewAnchorValue : LDACAAnchorValue!
    var videoViewAnchorValue : LDACAAnchorValue!
    
    var inputTextFieldAnchorValue : LDACAAnchorValue!
    


    
    var currentSelected  = [LDACheckListTableViewCellStatus]()
    var NameLabel = UILabel()
    var DescriptionLabel = UILabel()
    var ViewerButton = UIButton()
    var inputTextField = LDACATextView()
    var navView = LDACANavView()
    
    var urlEmbeddedWebView = URLEmbeddedView()
    var urlEmbeddedWebViewAnchorValue : LDACAAnchorValue!
  
    var urlEmbeddedWebViewCloseButtonAnchorValue : LDACAAnchorValue!
    var urlEmbeddedWebViewCloseButton = UIButton()
    var closeimage  = UIImage(named: "close")?.withRenderingMode(.alwaysTemplate)
    
    
    var embedingURL : String?
    
    var uploadvideoLocalURL : String?
    var uploadImage : UIImage?
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {

    }

    func textViewDidEndEditing(_ textView: UITextView) {
        self.detectURL()
    }
    
    let mediaPickVC =  FDTakeController()
    
    /*
    let TapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
    
    
    func register(viewController : UIViewController)
    {
        
        
       // NotificationCenter.default.addObserver(self, selector: #selector(LDAKeyboardHanlder.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
     //   NotificationCenter.default.addObserver(self, selector: #selector(LDAKeyboardHanlder.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    func dismissKeyboard() {
        
        
        self.view.endEditing(true)
        
    }
    

    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            
            
            
            self.view.addGestureRecognizer(TapGestureRecognizer)
            
            //   curerntViewController.view.addTarget(self, action: #selector(self.tapBlurButton(_:)), forControlEvents: .TouchUpInside)
            
            
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            
            
            if (self.view.gestureRecognizers?.contains(TapGestureRecognizer))!
            {
                
                self.view.removeGestureRecognizer(TapGestureRecognizer)
            }
            
            
            
            
        }
    }

*/
    //this cause crash
 //   var currentInbputString :String!
    func updateExtensionsHeight(height: CGFloat)
    {
                    self.urlEmbeddedWebViewAnchorValue.anchorValueWithLDACAAnchorKey(.heightConstant).constant = height
        
                            self.videoViewAnchorValue.anchorValueWithLDACAAnchorKey(.heightConstant).constant = height
        self.imageViewAnchorValue.anchorValueWithLDACAAnchorKey(.heightConstant).constant = height
        
  
    
    }
    func detectURL()
    {
      //  self.currentInbputString = self.inputTextField.text
        
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: self.inputTextField.text, options: [], range: NSRange(location: 0, length: self.inputTextField.text.utf16.count))
        
        
        
        
        if matches.count != 0
        {
            
            self.videoView.isHidden =  true
            self.urlEmbeddedWebView.isHidden =  false
            self.imageView.isHidden = true

            
            self.view.bringSubview(toFront: self.urlEmbeddedWebView)
       let url =  self.inputTextField.text.substring(with: (matches.first?.range.range(for: self.inputTextField.text)!)!)
            
            
        
           
            self.updateExtensionsHeight(height: 100)
            self.urlEmbeddedWebViewCloseButtonAnchorValue.anchorValueWithLDACAAnchorKey(.heightConstant).constant = 30
            self.urlEmbeddedWebViewCloseButtonAnchorValue.anchorValueWithLDACAAnchorKey(.widthConstant).constant = 30
            
            

            embedingURL = url
            
            self.uploadImage = nil
            self.uploadvideoLocalURL = ""
            
            
            self.view.layoutIfNeeded()
            
            self.urlEmbeddedWebView.loadURL(url)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                // your code here
                        self.urlEmbeddedWebView.loadURL(url)
            }

            
        
        }
        else{
            
            

            
        }
        //remove url in textinput
        for match in matches {
            let url = self.inputTextField.text.substring(with: match.range.range(for: self.inputTextField.text)!)
            
            print(url)
            
            self.inputTextField.text =    self.inputTextField.text.replacingOccurrences(of: url, with: "")
        }

        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        LDAKeyboardHanlder.shareInstance.register(viewController: self)
        
    }

    func initAllSelectedID()
    {
        currentSelected.removeAll()
        for item in self.viewerIDStringArr
        {
            currentSelected.append(.selected)
            
        }

    }
    func returnSelectValueFromCellStatusArr(statusArr:[LDACheckListTableViewCellStatus],Arr:[Int])->[String]
    {
        
        var selectedArr = [String]()
        
        var i = 0
        for item in statusArr
        {
            if item == LDACheckListTableViewCellStatus.selected
            {
                selectedArr.append(String(Arr[i]))
                
                
            }
            i += 1
        }
        
        
        return selectedArr
    }
    func handleDoneButtonTap()
    {
        
        
    }
     func handleCloseButtonTap()
    {

    }
    func handleCloseURLWebViewButtonTap()
    {
        
        
        
    }
    func closeURLWebViewHandle()
    {
        
        self.videoView.isHidden =  true
        self.urlEmbeddedWebView.isHidden =  true
        self.imageView.isHidden = true
        
        
        
        self.uploadImage = nil
        self.uploadvideoLocalURL = ""
        self.embedingURL = ""
        self.updateExtensionsHeight(height: 100)
        self.videoView.stop()
        
        
        
        
        
        
        self.view.layoutIfNeeded()

        
    }
    func buttonTapped(_ btn:LDAButton) {
   
    
    self.mediaPickVC.present()
        
        
        mediaPickVC.didGetPhoto = {
            (_ photo: UIImage, _ info: [AnyHashable : Any]) in
    
            
            
            self.videoView.isHidden =  true
            self.urlEmbeddedWebView.isHidden =  true
            self.imageView.isHidden = false
            
            self.imageView.image = photo
           
            
            self.updateExtensionsHeight(height: self.view.frame.size.width)
            
            
            self.urlEmbeddedWebViewCloseButtonAnchorValue.anchorValueWithLDACAAnchorKey(.heightConstant).constant = 20
            self.urlEmbeddedWebViewCloseButtonAnchorValue.anchorValueWithLDACAAnchorKey(.widthConstant).constant = 20
            
            self.view.layoutIfNeeded()

            
            
            
            
            
            self.view.bringSubview(toFront: self.imageView)

            
            self.uploadImage = photo
            self.uploadvideoLocalURL = ""
            self.embedingURL = ""

            
        }
        
        
        mediaPickVC.didGetVideo = {
            (_ video: URL, _ info: [AnyHashable : Any]) in
            
            self.videoView.isHidden =  false
            self.urlEmbeddedWebView.isHidden =  true
            self.imageView.isHidden = true
            
            self.updateExtensionsHeight(height: self.view.frame.size.width)
            self.urlEmbeddedWebViewCloseButtonAnchorValue.anchorValueWithLDACAAnchorKey(.heightConstant).constant = 20
            self.urlEmbeddedWebViewCloseButtonAnchorValue.anchorValueWithLDACAAnchorKey(.widthConstant).constant = 20

            self.view.layoutIfNeeded()

            
            self.videoView.beginPlayWithURL(video.absoluteString)
   //     self.videoView.beginPlayWithURL("http://news.video.vnecdn.net/video/web/mp4/2017/02/22/video-xu-phat-oto-222-1487742781.mp4")
            
            
            
            
            
            self.view.bringSubview(toFront: self.videoView)
            
            
            self.uploadImage = nil
            self.uploadvideoLocalURL = video.absoluteString
            self.embedingURL = ""


        
        }
        

        
        //didGetVideo: ((_ video: URL, _ info: [AnyHashable : Any]) -> Void)?

    }
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
       // let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
       // view.addGestureRecognizer(tap)
        self.videoView = ESVideoView(frame: CGRect.zero)



        
        
        
        
        self.videoButton.addTarget(self, action:#selector(self.buttonTapped(_:)), for:.touchUpInside)
        
        
        self.navView.embedToView(view: self.view)
        self.navView.DoneButton.setTitle("Post", for: .normal)
        self.navView.registerForReturnAction { (LDACANavViewReturnAction) in
            print("nav view action")
            if LDACANavViewReturnAction == .done
            {
                self.handleDoneButtonTap()
                
            }
            else
            {
                self.handleCloseButtonTap()
            }
            
            
            
        }
                self.inputTextField.LDACATextViewDelegate =  self as! UITextViewDelegate
        
        self.setupAppearance()
        self.setupAnchor()
        
        self.view.layoutSubviews()
        self.view.layoutIfNeeded()
        self.setupAction()
        // Do any additional setup after loading the view.
        
       // self.ViewerButton.imageView?.frame = CGRect(x: 0, y: 0, width: self.ViewerButton.frame.size.height, height: self.ViewerButton.frame.size.height)
      
        
        self.view.layoutSubviews()
        self.view.layoutIfNeeded()
        
        print(videoButton.frame)
 closeURLWebViewHandle()
    }
    
    func setupAction()
    {
        self.ViewerButton.addTarget(self, action: "viewerButtondidTouch", for: .touchDown)
    }
    func updateViewerButtonWithStatusArr(arr : [LDACheckListTableViewCellStatus],isAllSelected:Bool)
    {
    
    }
    func viewerButtondidTouch()
    {
//do not implement
    }
    func setupAppearance()
    {
        inputTextField.placeHolder = "Write Something"
        self.NameLabel.text = "User Name"
        
        self.ViewerButton.setTitle("All User", for: .normal)
        self.ViewerButton.layer.borderWidth = 0.4
        self.ViewerButton.layer.cornerRadius = 8
        self.ViewerButton.layer.masksToBounds =  true
        self.ViewerButton.layer.borderColor = UIColor.gray.cgColor
        
        
      //  inputTextField.borderStyle  = .roundedRect
        self.ViewerButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        self.ViewerButton.titleLabel?.textColor = UIColor.gray

        
        
        self.ViewerButton.setTitleColor(UIColor.gray, for: .normal)
        self.NameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        self.navView.backgroundColor = UIColor.rbg(r: 45, g: 135, b: 220)
        
        self.inputTextField.layer.borderWidth = 0.4
        self.inputTextField.layer.cornerRadius = 8
        self.inputTextField.layer.masksToBounds =  true
        self.inputTextField.layer.borderColor = UIColor.gray.cgColor
        self.urlEmbeddedWebViewCloseButton.addTarget(self, action: "closeURLWebViewHandle", for: .touchDown)

        
       
        urlEmbeddedWebViewCloseButton.setImage(closeimage, for: .normal)
        
        
        
        
        self.videoButton.setTitle("Video", for: .normal)
        
        self.videoButton.backgroundColor = UIColor.gray
   ///28 127 230
    }
    func setupAnchor()
    {
        self.view.addSubview(self.NameLabel)
        self.view.addSubview(self.inputTextField)

        self.view.addSubview(self.ViewerButton)
        self.view.addSubview(self.urlEmbeddedWebView)
        
        
        self.view.addSubview(self.urlEmbeddedWebViewCloseButton)
        self.view.addSubview(self.videoView)
        self.view.addSubview(self.imageView)

                self.view.addSubview(self.videoButton)
        
        

        

        
        print(navView.frame)
      //  navView.backgroundColor = UIColor.red
        
        
        self.NameLabel.anchor(self.navView.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.videoButton.leftAnchor, topConstant: 2, leftConstant: 2, bottomConstant: 0, rightConstant: 0, widthConstant: -1, heightConstant: -1)
        
        

      
        
        self.ViewerButton.anchor(self.NameLabel.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 4  , leftConstant: 80, bottomConstant: 0, rightConstant: 80, widthConstant: 80, heightConstant: 45)

        
    self.videoButton.anchor(self.ViewerButton.bottomAnchor, left: self.view.leftAnchor, bottom: self.inputTextField.topAnchor, right: nil, topConstant: 0, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 30)
        
        
        
        self.urlEmbeddedWebViewCloseButtonAnchorValue =       self.urlEmbeddedWebViewCloseButton.anchor(self.ViewerButton.bottomAnchor, left: nil, bottom: self.inputTextField.topAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 20)
        

        
        
        
  self.inputTextFieldAnchorValue =       self.inputTextField.anchor(self.videoButton.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 4, leftConstant: 4, bottomConstant: 0, rightConstant: 4, widthConstant: self.view.frame.size.width - 8, heightConstant: -1)
        
        
        
        
        
        
     self.videoViewAnchorValue =    self.videoView.anchor(self.inputTextField.bottomAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: -1, heightConstant: 0)
        
        self.imageViewAnchorValue =    self.imageView.anchor(self.inputTextField.bottomAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: -1, heightConstant: 0)
        



        

        self.urlEmbeddedWebViewAnchorValue =      self.urlEmbeddedWebView.anchor(self.inputTextField.bottomAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 2, leftConstant: 4, bottomConstant: 0, rightConstant: 4, widthConstant: self.view.frame.size.width - 8, heightConstant: 0)
        
    
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
