//
//  LDAOptionButtonView.swift
//  LDAContactApp
//
//  Created by Mac on 4/20/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit

protocol LDAOptionButtonViewDelegate{
    func LDAOptionButtonViewDidTouch(sender:LDAOptionButtonView)
}


@IBDesignable class LDAOptionButtonView: UIView {

    
    var delegate:LDAOptionButtonViewDelegate?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBInspectable var titleString: String = ""  {
        didSet {
            
            if let title = titleString as? String
            {
                
            print(titleString)
            self.titleLabel.text  = titleString
            }
        }
    }
    @IBInspectable var image: UIImage? {
        get {
            return imageView.image
        }
        set(image) {
            imageView.image = image
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        
        
    }
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    // Our custom view from the XIB file
    var view: UIView!
    
    func xibSetup() {
        
        

        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        view.backgroundColor = UIColor.clear
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
                self.imageView.backgroundColor = UIColor.clear
        self.setupGesture()

    }
    func handleTap(sender: AnyObject? = nil) {
        // handling code
        
        
        self.delegate?.LDAOptionButtonViewDidTouch(sender: self)
    }
    
    func setupGesture()
        
    {
        

        let tap = UITapGestureRecognizer(target: self, action:#selector(self.handleTap(sender:)))
        tap.numberOfTapsRequired  = 1
       // tap.delegate =  self
        self.addGestureRecognizer(tap)
    }


    
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "LDAOptionButtonView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }


}
