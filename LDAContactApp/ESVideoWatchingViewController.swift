//
//  ESVideoWatchingViewController.swift
//  LDAContactApp
//
//  Created by Mac on 5/26/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit

class ESVideoWatchingViewController: UIViewController {
    
     var videoView: ESVideoView!
    var navView = LDACANavView()

    override func viewDidLoad() {
     
        self.videoView = ESVideoView(frame: CGRect.zero)
        self.setupVideoView()
        self.videoView.beginPlayWithURL("http://news.video.vnecdn.net/video/web/mp4/2017/02/22/video-xu-phat-oto-222-1487742781.mp4")
        //https://www.dropbox.com/s/dw9i8ifhd6w261o/1632393030418290.mp4?dl=1

    }
    override func viewWillDisappear(_ animated: Bool) {
        self.videoView.stop()
    }
    func setupVideoView()
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
        
        self.view.addSubview(self.videoView)

        
        self.videoView.anchor(self.navView.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: -1, heightConstant: EnglishSocietyConfigurateVaribles.SharedInstance.ScreenSize.width)
        
    }
    
}
