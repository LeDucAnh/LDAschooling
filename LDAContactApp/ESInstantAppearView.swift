//
//  ESInstantAppearView.swift
//  HSUFreeWalkingtour
//
//  Created by Mac on 3/15/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit

open class LDAButton: UIButton {
   // var actionType = SCLActionType.none
    var target:AnyObject!
    //var selector:Selector!
    var action:(()->Void)!
    var customBackgroundColor:UIColor?
    var customTextColor:UIColor?
    var initialTitle:String!
    var showDurationStatus:Bool=false
    
    public init() {
        super.init(frame: CGRect.zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override public init(frame:CGRect) {
        super.init(frame:frame)
    }
    func registerActionTarget(action:@escaping ()->Void)
    {
                self.addTarget(self, action:#selector(self.buttonTapped(_:)), for:.touchUpInside)
        self.action = action
    }
    func buttonTapped(_ btn:LDAButton) {
        self.action()
    }

}


class ESVocabularyOptionView: UIView,ESTRanslateAPIDelegate
{
    internal func didCompleteTranslate(result: ESTranslateObject) {
        print(result)
        //    UIStoryboard(name: "MeaningTableViewStoryboard", bundle: nil).instantiateViewController(withIdentifier: "MainTableViewController") as! MeaningTableViewController
        
        
        

    }
    static var sharedInstante : ESVocabularyOptionView = {
        let view = ESVocabularyOptionView(frame:  CGRect(x: 5, y: -EnglishSocietyConfigurateVaribles.SharedInstance.ScreenSize.height - 80, width: EnglishSocietyConfigurateVaribles.SharedInstance.ScreenSize.width - 10, height: 80))
        
        

        return view
        
        }()
    var ESVocabularySpeakButton:LDAButton?
    var ESVocabularyOptionView_SeemoreBtn : LDAButton?
    var ESVocabularyOptionView_wordTitleLabel:UILabel?
        var exploringWord: String?
        {
            didSet {
             self.ESVocabularyOptionView_wordTitleLabel?.text = "Is that \"" + exploringWord! + "\" ?"
                self.ESVocabularyOptionView_wordTitleLabel?.numberOfLines = 0
                self.ESVocabularyOptionView_wordTitleLabel?.textColor = UIColor.white
            
            }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(backgroundColorAlphaFigure)
        self.layer.cornerRadius = 10.0
        self.setup()
    }
    
    let backgroundColorAlphaFigure:CGFloat = 0.8
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var allowToCancelView =  true
    func update()
    {
        self.cancelTimer.invalidate()
           self.cancelTimer = Timer()
         self.removeFromSuperview()
        
    }
    func setup()
    {
        
        self.ESVocabularySpeakButton =  LDAButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
           self.ESVocabularyOptionView_SeemoreBtn = LDAButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
      self.ESVocabularyOptionView_wordTitleLabel = UILabel(frame: CGRect.zero)
        self.ESVocabularySpeakButton?.translatesAutoresizingMaskIntoConstraints =  false
        self.ESVocabularyOptionView_wordTitleLabel?.translatesAutoresizingMaskIntoConstraints =  false
          self.ESVocabularyOptionView_SeemoreBtn?.translatesAutoresizingMaskIntoConstraints = false
        
        self.ESVocabularySpeakButton?.backgroundColor = UIColor.black.withAlphaComponent(0.7)
         self.ESVocabularyOptionView_SeemoreBtn?.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.ESVocabularySpeakButton?.registerActionTarget {
                 ESAnimation.shareInstance.executeGradientBorderAnimationFor(view: self.ESVocabularySpeakButton! ,colors: [UIColor.red.cgColor,UIColor.yellow.cgColor,UIColor.gray.cgColor])
          
            
            ESSpeakerHelper.sharedInstance.speak(speakingString: self.exploringWord!)
                            self.cancelTimer.invalidate()
            
                            self.cancelTimer =   Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
           
        }
        
        
         self.ESVocabularySpeakButton?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
        self.ESVocabularyOptionView_SeemoreBtn?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
self.ESVocabularyOptionView_wordTitleLabel?.font = UIFont.boldSystemFont(ofSize: 13.0)
        
        self.ESVocabularySpeakButton?.setTitle("SPEAK", for: .normal)

        self.ESVocabularyOptionView_SeemoreBtn?.setTitle("DETAIL", for: .normal)
       
        
                self.ESVocabularyOptionView_SeemoreBtn?.registerActionTarget {
            print("buttonTapped")
                    ESTranslateAPI.sharedInstance.delegate =  self
                    ESTranslateAPI.sharedInstance.RequestGoogleTranslateAPIWebview(self.exploringWord!)

                    self.removeFromSuperview()
        }
        
        
        
        self.addSubview(self.ESVocabularySpeakButton!)
        
        self.addSubview(self.ESVocabularyOptionView_SeemoreBtn!)
        self.addSubview(  self.ESVocabularyOptionView_wordTitleLabel!)
        //set constraint for detailButton
  
    

        let detailButtontopbotOffset = 13.0
        var  contraints =  NSLayoutConstraint(item: self.ESVocabularyOptionView_SeemoreBtn, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: -10.0)
        self.addConstraint(contraints)
        contraints =  NSLayoutConstraint(item: self.ESVocabularyOptionView_SeemoreBtn, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: CGFloat(detailButtontopbotOffset))
        self.addConstraint(contraints)
        contraints =  NSLayoutConstraint(item: self.ESVocabularyOptionView_SeemoreBtn, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: -(CGFloat)(detailButtontopbotOffset))
        self.addConstraint(contraints)
        
        contraints =  NSLayoutConstraint(item: self.ESVocabularyOptionView_SeemoreBtn, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: ESVocabularyOptionView_SeemoreBtn, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant:0)
        self.addConstraint(contraints)
        
        
        
        //set constraint for speakbutton
        
        contraints =  NSLayoutConstraint(item: self.ESVocabularySpeakButton, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: -(CGFloat)(detailButtontopbotOffset))
        self.addConstraint(contraints)
        contraints =  NSLayoutConstraint(item: self.ESVocabularySpeakButton, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self.ESVocabularySpeakButton, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: 0)
        self.addConstraint(contraints)
        contraints =  NSLayoutConstraint(item: self.ESVocabularySpeakButton, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: CGFloat(detailButtontopbotOffset))
        self.addConstraint(contraints)
        contraints =  NSLayoutConstraint(item: self.ESVocabularySpeakButton, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.ESVocabularyOptionView_SeemoreBtn, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: -20.0)
        self.addConstraint(contraints)
        
        
        //set contraint for title label
        contraints =  NSLayoutConstraint(item: self.ESVocabularyOptionView_wordTitleLabel, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: -4.0)
        self.addConstraint(contraints)
        contraints =  NSLayoutConstraint(item: self.ESVocabularyOptionView_wordTitleLabel, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.ESVocabularySpeakButton, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 8)
        self.addConstraint(contraints)
        contraints =  NSLayoutConstraint(item: self.ESVocabularyOptionView_wordTitleLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 4.0)
        self.addConstraint(contraints)
        contraints =  NSLayoutConstraint(item: self.ESVocabularyOptionView_wordTitleLabel, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 5.0)
        self.addConstraint(contraints)

        
        
        
       
        self.layoutSubviews()
        self.layoutIfNeeded()
        
    }
    var cancelTimer = Timer()
    func show(word:String)
    {
       
        self.exploringWord = word
        let rv = UIApplication.shared.keyWindow! as UIWindow
        
        var animationStartOrigin = self.frame.origin
        var animationCenter : CGPoint = rv.center
            if rv.subviews.contains(ESVocabularyOptionView.sharedInstante)
            {
                ESVocabularyOptionView.sharedInstante.removeFromSuperview()


                 // ESTranslateAPI.sharedInstance.RequestGoogleTranslateAPIWebview(word, ViewController: self)
            }
        rv.addSubview(ESVocabularyOptionView.sharedInstante)
        animationStartOrigin = CGPoint(x: animationCenter.x, y:  -self.frame.size.height - 20)
      //  animationStartOrigin = CGPoint(x: animationCenter.x, y:   -20)
        
        animationCenter = CGPoint(x: animationCenter.x, y:rv.frame.size.height - self.frame.size.height/2 - 40)
        animationCenter = CGPoint(x: animationCenter.x, y:EnglishSocietyConfigurateVaribles.SharedInstance.ScreenSize.height - 100)
        
        print(animationStartOrigin)
        print(animationCenter)
        
        self.frame.origin = animationStartOrigin
        self.alpha = 1.0

        UIView.animate(withDuration: 0.5, animations: {
                        self.backgroundColor = UIColor.black.withAlphaComponent(self.backgroundColorAlphaFigure)

            self.center = animationStartOrigin
        }, completion: { finished in
            
            UIView.animate(withDuration: 1, animations: {
                self.center = animationCenter
                ESAnimation.shareInstance.shakeView(self, updown: 1.5, leftright: 0.3)
                self.animate()
                
                
                self.cancelTimer.invalidate()
            self.cancelTimer =   Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
                /*
                 DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4) {
                 ESAnimation.shareInstance.fadeOutToAlpha(self, toAlpha: 0.8, withDuration: 1)
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
                    ESAnimation.shareInstance.fadeOut(self, withDuration: 2)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                        if self.allowToCancelView == true
                        {
                        self.removeFromSuperview()
                            self.allowToCancelView =  true
                        }
                        
                    }
                    
                }
                */
                
                
                
            })
        })

        
    }
    func animate()
    {
        print(ESVocabularyOptionView_SeemoreBtn?.frame)
        print(ESVocabularySpeakButton?.frame)
        print(ESVocabularySpeakButton?.layer.frame)
        //animation
        self.ESVocabularyOptionView_SeemoreBtn?.layer.cornerRadius = (ESVocabularyOptionView_SeemoreBtn?.frame.size.height)!/2
        
        self.ESVocabularySpeakButton?.layer.cornerRadius = (ESVocabularySpeakButton?.frame.size.height)!/2
        ESAnimation.shareInstance.executeGradientBorderAnimationFor(view:
            (ESVocabularyOptionView_SeemoreBtn)! ,colors: [UIColor.red.cgColor,UIColor.green.cgColor,UIColor.gray.cgColor])
        ESAnimation.shareInstance.executeGradientBorderAnimationFor(view: self.ESVocabularySpeakButton! ,colors: [UIColor.red.cgColor,UIColor.yellow.cgColor,UIColor.gray.cgColor])

        //let borer  = ESAnimation()z
       // borer.executeGradientBorderAnimationFor(view:  (ESVocabularyOptionView_SeemoreBtn)!)
       // DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
        
         //   let borer2  = ESAnimation()
           // borer2.executeGradientBorderAnimationFor(view:  (self.ESVocabularySpeakButton)!)
       // }
       
        
        
    }
}
class ESInstantAppearView: UIViewController {
    
    func checkValideFrame(frame:CGRect)->Bool
    {
        
        if frame.origin.x >  self.view.frame.size.width || frame.origin.x < -frame.size.width
        {
            return false
        }
        if frame.origin.y >  self.view.frame.size.height || frame.origin.y < -frame.size.height
        {
                return false
        }
        return true
    
    }
    func showAnimation()
    {
        
        let rv = UIApplication.shared.keyWindow! as UIWindow
        var animationStartOrigin = self.view.frame.origin
        var animationCenter : CGPoint = rv.center
        
        
            animationStartOrigin = CGPoint(x: animationCenter.x, y:  -self.view.frame.size.height - 20)
            animationCenter = CGPoint(x: animationCenter.x, y:rv.frame.size.height - self.view.frame.size.height/2 - 40)
        print(animationStartOrigin)
        print(animationCenter)
        
        self.view.frame.origin = animationStartOrigin
        UIView.animate(withDuration: 0.005, animations: {
            self.view.alpha = 1.0
            self.view.center = animationStartOrigin
        }, completion: { finished in
            
            UIView.animate(withDuration: 1, animations: {
                self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                self.view.center = animationCenter
            })
        })

    }
    
    func showView(offSetToScreenWidth:CGFloat,height:CGFloat)
    {
        let rv = UIApplication.shared.keyWindow! as UIWindow
        rv.addSubview(view)
         view.frame = CGRect(x: offSetToScreenWidth, y: (UIApplication.shared.keyWindow?.bounds)!.size.height/2 -  height/2, width: (UIApplication.shared.keyWindow?.bounds)!.size.width - offSetToScreenWidth*2, height: height)
        
                // baseView.frame = rv.bounds
        self.showAnimation()

    }
    open func addButton(_ title:String, backgroundColor:UIColor? = nil, textColor:UIColor? = nil, showDurationStatus:Bool=false,frameView:CGRect, action:@escaping ()->Void)->LDAButton {
       
        /*
        let btn = addButton(title, backgroundColor: backgroundColor, textColor: textColor, showDurationStatus: showDurationStatus)
        btn.actionType = SCLActionxType.closure
        btn.action = action
        btn.addTarget(self, action:#selector(SCLAlertView.buttonTapped(_:)), for:.touchUpInside)
        btn.addTarget(self, action:#selector(SCLAlertView.buttonTapDown(_:)), for:[.touchDown, .touchDragEnter])
        btn.addTarget(self, action:#selector(SCLAlertView.buttonRelease(_:)), for:[.touchUpInside, .touchUpOutside, .touchCancel, .touchDragOutside] )
        return btn
    */
        
        assert(checkValideFrame(frame: frameView), "button are out of view")
        

        let btn =  LDAButton(frame: frameView)
        self.view.addSubview(btn)
        self.view.bringSubview(toFront: btn)
        
        btn.action = action

        btn.addTarget(self, action:#selector(ESInstantAppearView.buttonTapped(_:)), for:.touchUpInside)
        
        return btn
        
        
    }

    func buttonTapped(_ btn:LDAButton) {
                   btn.action()
        /*
        if btn.actionType == SCLActionType.closure {
            btn.action()
        } else if btn.actionType == SCLActionType.selector {
            let ctrl = UIControl()
            ctrl.sendAction(btn.selector, to:btn.target, for:nil)
        } else {
            print("Unknow action type for button")
        }
        
        if(self.view.alpha != 0.0 && appearance.shouldAutoDismiss){ hideView() }
 */
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */


}
