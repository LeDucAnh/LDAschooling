//
//  LDACANotificationPostViewController.swift
//  LDAContactApp
//
//  Created by Mac on 6/15/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit

class LDACAAppNotificationPostViewController: UIViewController,SPSegmentControlCellStyleDelegate, SPSegmentControlDelegate {

    
    
    
   
    
    let segmentedСontrol = SPSegmentedControl.init()
    
    private let borderColor: UIColor = UIColor(hue: 1, saturation: 0, brightness: 1, alpha: 0.5)
    private let backgroundColor: UIColor = UIColor(hue: 1, saturation: 0, brightness: 1, alpha: 0.08)


    
    var PostNotiVC = LDACAPostNotificationViewController()
    
    func configurecPostNotificationVC()
    {
        
        

        
        PostNotiVC.videoButton.anchor(PostNotiVC.view.topAnchor, left: PostNotiVC.view.leftAnchor, bottom: PostNotiVC.inputTextField.topAnchor, right: nil, topConstant: 2, leftConstant: 4, bottomConstant: 4, rightConstant: 0, widthConstant: 60, heightConstant: 35)


        
 
        
        
        PostNotiVC.ViewerButton.removeFromSuperview()
        
        PostNotiVC.navView.removeFromSuperview()
        PostNotiVC.NameLabel.removeFromSuperview()
        
        
        
        
        PostNotiVC.view.layoutIfNeeded()
        PostNotiVC.view.layoutSubviews()
    }

   
    var options = ["Student","Teacher","Staff","All user"]
    init() {
    
        super.init(nibName: nil, bundle: nil)
        
        print(self.view.frame)
        
        
        
        segmentedСontrol.layer.borderColor = self.borderColor.cgColor
        segmentedСontrol.backgroundColor = self.backgroundColor
        segmentedСontrol.styleDelegate = self
        segmentedСontrol.delegate = self


        var i = 0
        for item in options
        {
            let cell = SPSegmentedControlCell.init()
            cell.label.text = options[i]
            cell.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
            
            //cell.imageView.image = UIImage(named: "call")?.withRenderingMode(.alwaysTemplate)
            cell.layout = .textWithImage
            
            self.segmentedСontrol.add(cell: cell)
            i += 1
            
        }
        
        

        

        
        self.view.addSubview(self.segmentedСontrol)

        
        self.view.addSubview(self.PostNotiVC.view)

        
        self.segmentedСontrol.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: self.PostNotiVC.view.topAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 2, bottomConstant: 0, rightConstant: 2, widthConstant: -1, heightConstant: 45)
        
        //self.inputTextField.anchor(self.segmentedСontrol.bottomAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 2, leftConstant: 2, bottomConstant: 2, rightConstant: 2, widthConstant: -1, heightConstant: 0)
        
        
        
        self.PostNotiVC.view.anchor(self.segmentedСontrol.bottomAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 2, leftConstant: 2, bottomConstant: 2, rightConstant: 2, widthConstant: -1, heightConstant: 380)
        

        
        
        
        
        
        
        
        self.view.layoutIfNeeded()
        self.view.layoutSubviews()
      
        print(self.segmentedСontrol.frame)
        print(self.PostNotiVC.view.frame)
        self.view.backgroundColor = UIColor.clear
       
        
        configurecPostNotificationVC()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func selectedState(segmentControlCell: SPSegmentedControlCell, forIndex index: Int) {
        SPAnimation.animate(0.1, animations: {
            segmentControlCell.imageView.tintColor = UIColor.green
        })
        
        UIView.transition(with: segmentControlCell.label, duration: 0.1, options: [.transitionCrossDissolve, .beginFromCurrentState], animations: {
            segmentControlCell.label.textColor = UIColor.green
        }, completion: nil)
    }
    
    func normalState(segmentControlCell: SPSegmentedControlCell, forIndex index: Int) {
        SPAnimation.animate(0.1, animations: {
            segmentControlCell.imageView.tintColor = UIColor.white
        })
        
        UIView.transition(with: segmentControlCell.label, duration: 0.1, options: [.transitionCrossDissolve, .beginFromCurrentState], animations: {
            segmentControlCell.label.textColor = UIColor.white
        }, completion: nil)
    }
    
    func indicatorViewRelativPosition(position: CGFloat, onSegmentControl segmentControl: SPSegmentedControl) {
        let percentPosition = position / (segmentControl.frame.width - position) / CGFloat(segmentControl.cells.count - 1) * 100
        let intPercentPosition = Int(percentPosition)
      //  self.percentIndicatorViewLabel.text = "scrolling: \(intPercentPosition)%"
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
