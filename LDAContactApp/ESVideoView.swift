//
//  ESVideoView.swift
//  EnglishSociety
//
//  Created by Mac on 10/25/16.
//  Copyright © 2016 LeDucAnh. All rights reserved.
//

import UIKit
import AVFoundation
//interface
@objc public protocol ESVideoViewDelegate:NSObjectProtocol
{
    func didBeginToPlay()
    func didBeginToPause()
    func willBeinToPlay()
   @objc optional func didTapToPause()
}

class ESVideoView: UIView,UIGestureRecognizerDelegate {
   
    
    
    internal override func clone() -> UIView {
        if self.VidString != "" {
        let videoView = ESVideoView(vidURLString: self.VidString!)
        
        videoView.frame.size  = self.frame.size
            return videoView
        }
        return ESVideoView()
        
    }

    func decompositionInstance()
    {
        
    }

    var playerplayer:AVPlayerLayer?
    var player :AVPlayer?
        var VidTimer :Timer?
    var BlurCornerRadius = 0
    weak open var delegate:ESVideoViewDelegate?
    var DoesUseBlurEff = false
    var visualEffectView : UIVisualEffectView?
    var TimeProgessView:ESCountDownTimerView?
    var VidString:String?
    var VidPlayerCurrentMode :ESVideoRenderMode = .notAllow
    var IsuserStillTouching:Bool = false
    let loadingLabel = UILabel()
    
    var thumbnailImage : UIImage?
    var thumbnailImageView = UIImageView()
  
    public enum ESVideoRenderMode {
        case allow
        case notAllow
    }

    func seekPlayerTotimeasBeginning(_ thumbnailtime:Double)
    {
        let timeScale = self.player?.currentItem?.asset.duration.timescale
        
        let changedtime =    CMTime(seconds: thumbnailtime, preferredTimescale: timeScale!)
        
        self.player?.seek(to: changedtime)
        self.player?.pause()

    }
    
    
    func beginPlayWithURL(_ vidURLString:String)
  {
    
    self.reset()
   
    self.setupGesture()
    
    
    DispatchQueue.main.async {
        
        self.loadingLabel.frame = CGRect(x: self.frame.size.width/2 - 50, y: self.frame.size.height - 50  , width: 100, height: 40)
        self.backgroundColor = UIColor.clear
                self.loadingLabel.alpha = 1.0
        
        ESAnimation.shareInstance.shakeView(self.loadingLabel)

    }
    
        /*
        AVAsset *currentPlayerAsset = player.currentItem.asset;
        // make sure the current asset is an AVURLAsset
        if (![currentPlayerAsset isKindOfClass:AVURLAsset.class]) return nil;
        // return the NSURL
        return [(AVURLAsset *)currentPlayerAsset URL];
 */
        var currentPlayerurl = "-1"
       if let currentPlayerAsset =  self.player?.currentItem?.asset as? AVURLAsset
        
       {
        let urlasset = currentPlayerAsset 
        currentPlayerurl = urlasset.url.absoluteString
        
        }
        
        if currentPlayerurl != vidURLString
        {
        let videoURL = URL(string: vidURLString)
        
        self.player  = AVPlayer(url: videoURL! as URL)


        self.playerplayer = AVPlayerLayer(player: self.player)
        //self.playerplayer?.isHidden = true
            DispatchQueue.main.async {
    self.playerplayer?.frame = self.frame
        self.setupPlayerFrame()
        
        self.playerplayer?.frame.origin = CGPoint(x: 0, y: 0)
    self.layer.addSublayer(self.playerplayer!)
                self.playerplayer?.videoGravity = AVLayerVideoGravityResize
                
                //  self.playerplayer?.videoGravity =
               //AVLayerVideoGravityResizeAspectFill
                self.isUserInteractionEnabled = true
            }
    self.setupprocess()
      

  

    
    }
    
    }
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.reset()

        self.frame =  frame
                self.reset()
        self.loadingLabel.text = "Loading"
        self.loadingLabel.textColor = UIColor.white
        self.loadingLabel.alpha = 0.0
        print(self.frame.size.width)
        print(self.frame.size.height)
        self.loadingLabel.frame = CGRect(x: 50, y: 50, width: 100, height: 40)
        self.addSubview(self.loadingLabel)
        self.bringSubview(toFront: self.loadingLabel)
        self.loadingLabel.layer.zPosition = 5
        self.loadingLabel.textAlignment = .center
       self.loadingLabel.layer.masksToBounds = true
        self.loadingLabel.layer.cornerRadius = 10.0
        
        self.loadingLabel.backgroundColor = EnglishSocietyConfigurateVaribles.SharedInstance.ESDarkBlack.withAlphaComponent(0.8)
     
        self.setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
    }


    
    
     convenience init (vidURLString:String) {
        let width = UIScreen.main.bounds.size.width
        let rect = CGRect(x: 0, y: 0, width: width, height: width)
            self.init(frame:rect)
            
          self.setupGesture()
        
VidString = vidURLString
        
           let videoURL = URL(string: vidURLString)
        
        let playerItem = AVPlayerItem( url:videoURL!  )
     
               self.player  = AVPlayer(playerItem:playerItem)
            self.playerplayer = AVPlayerLayer(player: player)
        
            playerplayer?.frame = rect
        self.setupPlayerFrame()
        self.layer.addSublayer(playerplayer!)
        self.isUserInteractionEnabled = true
        self.setupprocess()
        player?.rate = 1.0;
        player?.play()
    
    }
    func setupPlayerFrame()
    {
      //  self.playerplayer?.frame.size.height -= CGFloat(20.0)
    }
    func setupprocess()
    {
        
        
        self.superview?.layoutSubviews()
        self.layoutSubviews()
        print(self.frame.size.width)
        DispatchQueue.main.async {
            

        self.TimeProgessView?.removeFromSuperview()
        //self.TimeProgessView = ESCountDownTimerView(frame: CGRect(x: 0, y: self.frame.size.height - 25, width: UIScreen.main.bounds.size.width, height: 25))
            self.TimeProgessView = ESCountDownTimerView(frame: CGRect(x: 0, y: self.frame.size.height - 4, width: self.frame.size.width, height: 4))
            
        self.addSubview(self.TimeProgessView!)
    //    self.TimeProgessView?.layer.zPosition = 1
    

        self.TimeProgessView?.backgroundColor = ESCountDownTimerView.shareinstance.backgroundPlayingColor
        
        }
    }
    
    func removeAllGesture()
    {
        for recognizer in self.gestureRecognizers ?? [] {
            self.removeGestureRecognizer(recognizer)
        }

    }
    func setupGesture()
    {
        
     /*
        let swipeRight = UISwipeGestureRecognizer(target: self, action:#selector(self.respondToSwipeGesture(gesture:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        swipeRight.delegate =  self
        self.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action:#selector(self.respondToSwipeGesture(gesture:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        swipeLeft.delegate = self
        self.addGestureRecognizer(swipeLeft)
       */
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.TapOnView(_:)))
        tapGesture.numberOfTapsRequired =  1
        tapGesture.delegate = self
            self.addGestureRecognizer(tapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action:#selector(self.handlePanGesture(_:)))
        panGesture.delegate = self
        
        self.addGestureRecognizer(panGesture)

        
    }

    func TapOnView(_ sender: UITapGestureRecognizer) {
        print("Tap")
        DispatchQueue.main.async {
            
            
            self.handleTapGesture()
        }
    }

    func handlePanGesture(_ sender :UIPanGestureRecognizer)
    {
        //        get translation
        
        let translation = sender.translation(in: self)
        sender.setTranslation(CGPoint.zero, in: self)
        print("translation : \(translation)")
        
        /*
        //create a new Label and give it the parameters of the old one
        var label = panGesture.view as UIImageView
        label.center = CGPoint(x: label.center.x+translation.x, y: label.center.y+translation.y)
        label.multipleTouchEnabled = true
        label.userInteractionEnabled = true
         */
        
     
        if sender.state == UIGestureRecognizerState.began {
            
            IsuserStillTouching = true
            
            
            self.pause()
            
            //add something you want to happen when the Label Panning has started
        }
        
        if sender.state == UIGestureRecognizerState.ended {
            
            //add something you want to happen when the Label Panning has ended/
            /*   if translation.x < 0
             {
             
             self.backwardPlayer(duration: -1 * Double(translation.x))
             }
             else{
             
             self.forwardPlayer(duration: Double(translation.x))
             
             }*/
            IsuserStillTouching = false
            self.setPlayerAfterRender()
            self.seektoTimeAsProcessbar()
            self.play()
        }
        
        
        if sender.state == UIGestureRecognizerState.changed {
            
         
         self.updateProcessBar(Double(translation.x))
            //add something you want to happen when the Label Panning has been change ( during the moving/panning )
            
        }
            
        else {
            
            // or something when its not moving
        }

    }
    func setPlayerAfterRender()
    {
        DispatchQueue.main.async {
            
            self.VidPlayerCurrentMode = .notAllow
            self.TimeProgessView?.backgroundColor = ESCountDownTimerView.shareinstance.backgroundPlayingColor
            
        }

    }
    
    func forwardPlayer(_ duration:Double)
    {
        let timeScale = self.player?.currentItem?.asset.duration.timescale
        let plustime =      (self.player?.currentTime())! + CMTime(seconds: Double(duration), preferredTimescale: timeScale!)
        
        self.player?.seek(to: plustime)
        
      
    }
    func backwardPlayer(_ duration:Double)

    {
       
        let timeScale = self.player?.currentItem?.asset.duration.timescale
        
        var plustime =      (self.player?.currentTime())! - CMTime(seconds: 2, preferredTimescale: timeScale!)
      
       if  CMTimeGetSeconds(plustime) < 0.0
       {
            plustime = CMTime(seconds: 0, preferredTimescale: timeScale!)
        }
        
        self.player?.seek(to: plustime)
        
    }
    func handleTapGesture()
    {
    
//rate = 0  video paused 
        //rate != 0 video is playing
        if ((self.player?.rate != 0) && (self.player?.error == nil)) {
            // player is playing
            
            self.VidPlayerCurrentMode = .allow
            let currentbackground = self.TimeProgessView?.backgroundColor
            self.TimeProgessView?.backgroundColor = ESCountDownTimerView.shareinstance.backgroundRenderingColor
            /*
            let deadlineTime = DispatchTime.now() + .seconds(1)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                
                if self.IsuserStillTouching == false
                {
                    self.VidPlayerCurrentMode = .notAllow
                    
                    self.TimeProgessView?.backgroundColor = ESCountDownTimerView.shareinstance.backgroundPlayingColor
                    self.play()
                }
            
            }
             */
            
            
          
                self.pause()
            self.didTapToPause()
                }
        else{
            
            //video is pausing
            self.setPlayerAfterRender()
            
            self.play()
        }
    }

    func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            if gesture.state == UIGestureRecognizerState.ended {
           print("end")
            }
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
                self.forwardPlayer(1)
          
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
                self.backwardPlayer(2)
        
            default:
                break
            }
        }
    }
    func play()
    {
        
        DispatchQueue.main.async {

        self.willBeginToPlay()
        }
//this main thread may cause some lag
       //  DispatchQueue.main.async {
                    self.TimeProgessView?.backgroundColor  = ESCountDownTimerView.shareinstance.backgroundPlayingColor
        
       //  }
        if CMTimeGetSeconds((self.player?.currentTime())!) == CMTimeGetSeconds((self.player?.currentItem?.asset.duration)!)
     {
        self.player?.seek(to: CMTime(seconds: 0, preferredTimescale: (self.player?.currentItem?.asset.duration.timescale)!))

        }
        
          DispatchQueue.main.async {

          self.player?.play()
            
        self.VidTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
           // SwiftSpinner.show("Wait")
        }
        

    }
    func removePlayerLayer()
    {
        //self.player = nil
        self.playerplayer?.removeFromSuperlayer()
        
    }
    func didBeginToPause()
    {
        self.delegate?.didBeginToPause()

    }
    func didBeginToPlay()
    {
        self.delegate?.didBeginToPlay()
    }
    func willBeginToPlay()
    {
        self.delegate?.willBeinToPlay()
    }
    func didTapToPause()
    {
        if self.delegate?.didTapToPause!() != nil
        {
        self.delegate?.didTapToPause!()
        }
    }
    func pause()
    {   //newline
        self.didBeginToPause()
        //----
        player?.pause()
        self.VidTimer?.invalidate()
        self.VidTimer =  nil
    }
    func stop()
    {
        if let play = player {
            self.pause()
            
            player = nil
            print("player deallocated")
        } else {
            print("player was already deallocated")
        }

    }
    func seektoTimeAsProcessbar()
    {
        
        let current =  (self.TimeProgessView?.frame.size.width)!
        let total = self.frame.size.width

        let ratio = Double(current/total)
        let seektimeinDouble  = Double(CMTimeGetSeconds((self.player?.currentItem?.asset.duration)!)) * ratio
                let timeScale = self.player?.currentItem?.asset.duration.timescale
       
        let changedtime =    CMTime(seconds: Double(seektimeinDouble), preferredTimescale: timeScale!)
        
        self.player?.seek(to: changedtime)
        

    }
    @objc fileprivate  func updateProcessBar(_ changeValue:Double) {
        
        let current =  (self.TimeProgessView?.frame.size.width)! + CGFloat(changeValue)
       
        if current <= 0
        {
            return
        }
        
        print(changeValue)
       print("current \(current)")
        //2 is just in case 
        let total = (self.TimeProgessView?.originalWidth)!
        
        if current != 0  && total != 0
        {
            self.TimeProgessView?.setValue(Double(current), Double(total))
            
           // self.TimeProgessView?.setValue(currentValue: Double(current), maxValue: Double(total))
        }
        else {
            //self.TimeProgessView?.setValue(currentValue: 0, maxValue: 1)
            self.TimeProgessView?.setValue(0.0, 1.0)

        }
        
        
    }

    
    @objc fileprivate  func update() {
       
        
   
      if  self.VidPlayerCurrentMode == .allow
      {
        return
        
        }
        DispatchQueue.main.async {

        if self.loadingLabel.alpha  == 0.0
        {
            
            self.loadingLabel.alpha = 1.0
         
            ESAnimation.shareInstance.shakeView(self.loadingLabel, updown: 3, leftright: 1)
        }
        else
        {
            
            self.loadingLabel.alpha = 0.0
        }
        }

        self.TimeProgessView?.backgroundColor =      ESCountDownTimerView.shareinstance.backgroundPlayingColor
    //current time and total time
        let current  = Double(CMTimeGetSeconds((self.player?.currentTime())!))
        let total = Double(CMTimeGetSeconds((self.player?.currentItem?.asset.duration)!))
       let urlasset =  self.player?.currentItem?.asset as! AVURLAsset
        //print(urlasset.url.absoluteURL)
        if current != 0  && total != 0
        {
            //is playing video
            
            self.TimeProgessView?.setValue(Double(current), Double(total))
            

            //self.TimeProgessView?.setValue(currentValue: current, maxValue: total)
        //call block to run on main thread
            DispatchQueue.main.async {
                //hide loading label
                self.loadingLabel.alpha = 0.0
                self.didBeginToPlay()

            }
        }
        else {
            
            self.TimeProgessView?.setValue( 0,  1)
        }
        
        if current == total
        {    self.TimeProgessView?.setValue( 1,  1)
           self.VidTimer?.invalidate()
            self.VidTimer = nil
            print("done")
            
        }
        
       
    
    }
    func toggleBlurEffect()
    {
        if self.DoesUseBlurEff == true
        {
        self.visualEffectView?.removeFromSuperview()
        DoesUseBlurEff =  false
        }
        else{
            
            let effect =    UIBlurEffect(style: .dark)
            self.visualEffectView = UIVisualEffectView(effect: effect)
            visualEffectView?.alpha = 1
            visualEffectView?.layer.cornerRadius = CGFloat(BlurCornerRadius)
            visualEffectView?.clipsToBounds = true
                        visualEffectView?.frame = self.bounds
            print(self.bounds)
          self.addSubview(visualEffectView!)
            DoesUseBlurEff =  true

        }
    }

        func reset ()
        {
            
            self.DoesUseBlurEff =  false
            self.VidPlayerCurrentMode = .notAllow
            
        }
        func startCountDown(_ startTime:Double)
        {
            
            
            
        }
        
    
    /*
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch begin ")
        IsuserStillTouching = true
    }
     func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        
    }
     override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch end")
        IsuserStillTouching = false
    }
 */

     override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isKind(of: UIPanGestureRecognizer.self)
        {
            let panGes = gestureRecognizer as! UIPanGestureRecognizer
   
            let velocity =             panGes.velocity(in: self)
            if abs(velocity.y) < abs(velocity.x)
            {
                 self.VidPlayerCurrentMode = .notAllow
            }
            
             //return abs(velocity.y) < abs(velocity.x)
            

        }
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
       // print("being Recognizing 2")
        
         if gestureRecognizer.isKind(of: UIPanGestureRecognizer.self)
         {
         if let panges = gestureRecognizer as? UIPanGestureRecognizer
         {
        
            /*
         var translation = panges.translation(in: self)
         panges.setTranslation(CGPoint.zero, in: self)
         print("translation : \(translation)")
         if translation.x == 0.0
         {
         return false
         }
             */
            if self.VidPlayerCurrentMode == .notAllow{
                return false
            }
         
            
            
        }
         
         
        }
         return true
 
        

     return true
        
    }
 
    
    
    
    

}
