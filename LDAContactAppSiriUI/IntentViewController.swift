//
//  IntentViewController.swift
//  LDAContactAppSiriUI
//
//  Created by Mac on 6/8/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import IntentsUI

// As an example, this extension's Info.plist has been configured to handle interactions for INSendMessageIntent.
// You will want to replace this or add other intents as appropriate.
// The intents whose interactions you wish to handle must be declared in the extension's Info.plist.

// You can test this example integration by saying things to Siri like:
// "Send a message using <myApp>"

class IntentViewController: UIViewController, INUIHostedViewControlling,INUIHostedViewSiriProviding {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var absentLabel: UILabel!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var nameLabel: UILabel!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var displaysMessage: Bool {
        return        true

    }

    let wormhole = MMWormhole(applicationGroupIdentifier: "group.LeDucAnh.LDAContactApp", optionalDirectory: "sirikitexample")

    override func viewDidAppear(_ animated: Bool) {
        self.blurView.alpha = 0.953
        self.view.bringSubview(toFront: self.blurView)
        self.view.bringSubview(toFront: self.nameLabel)

        self.view.bringSubview(toFront: self.absentLabel)

        wormhole.listenForMessage(withIdentifier: "intent.content") { (object) in
            
          //  self.extensionContext?.open(NSURL(string: "foo://startPlaying")! as URL, completionHandler: nil)
        }
        
    }
    // MARK: - INUIHostedViewControlling
    
    // Prepare your view controller for the interaction to handle.
    func configure(with interaction: INInteraction!, context: INUIHostedViewContext, completion: ((CGSize) -> Void)!) {
        // Do configuration here, including preparing views and calculating a desired size for presentation.
        if interaction.intent is INSendMessageIntent {
            let intent = interaction.intent as! INSendMessageIntent
            
            self.nameLabel.text = intent.recipients?.first?.displayName
            
            if let content = intent.content as? String
            {
                let (intentObject,bool) =  LDAIntentAbsentObject.shareInstance.getIntentObjectFrom(intentString: content)
                if bool
                {
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MMM dd,yyyy"
                    
                    
                absentLabel.isHidden =  false
                absentLabel.text = "Absent On " + intentObject.composeDateToString() + "\n Which is " +                     dateFormatter.string(from: intentObject.returnDate())
                    
                    
                }
                else
                {
                                    absentLabel.text = intent.content
                }
                
            }
        }

        if let completion = completion {
            completion(self.desiredSize)
        }
    }
    
    var desiredSize: CGSize {
        return self.extensionContext!.hostedViewMaximumAllowedSize
    }
    
}
