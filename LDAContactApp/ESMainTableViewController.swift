//
//  MainTableViewController.swift
//
// Copyright (c) 21/12/15. Ramotion Inc. (http://ramotion.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import ObjectiveC
class MeaningViewController :UIViewController{
    static var sharedInstance =   UIStoryboard(name: "ESMeaningTableViewStoryboard", bundle: nil).instantiateViewController(withIdentifier: "MeaningViewController") as! MeaningViewController
    var meaningVC =  MeaningTableViewController()

    @IBOutlet weak var MeaningVCControlView: UIView!
    @IBOutlet weak var specificLanguageHorizontalView: LDAHorizontalScrollOptionView!
    @IBOutlet weak var toLanguageMeaningsLabel: UILabel!
    @IBAction func CloseButtonDidTouch(_ sender: Any) {
        self.meaningVC.closeAllMeaningViews()
    }
    override func viewDidLoad() {
     //self.setup()
    }
    
    func setupConstraints(){
        
        self.meaningVC.view.translatesAutoresizingMaskIntoConstraints =  false
        var  contraints =  NSLayoutConstraint(item: self.meaningVC.view, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 0.0)
        self.view.addConstraint(contraints)
        contraints =  NSLayoutConstraint(item: self.meaningVC.view, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0.0)
        self.view.addConstraint(contraints)
        contraints =  NSLayoutConstraint(item: self.meaningVC.view, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0)
        self.view.addConstraint(contraints)

        contraints =  NSLayoutConstraint(item: self.meaningVC.view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.MeaningVCControlView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0)
        self.view.addConstraint(contraints)

        
        
        

    }
    func displayMeaningofWordTo(frame:CGRect,translateObject:ESTranslateObject)
    {
        
        //   let storyboard = UIStoryboard(name: "MeaningTableViewStoryboard", bundle: nil)
        
        
        //  MeaningTableViewController.sharedInstance = storyboard.instantiateViewController(withIdentifier: "MainTableViewController") as! MeaningTableViewController
       // self.meaningVC = nil
        
       // if meaningVC == nil
      //  {
            self.meaningVC =  UIStoryboard(name: "ESMeaningTableViewStoryboard", bundle: nil).instantiateViewController(withIdentifier: "MainTableViewController") as! MeaningTableViewController
            
            
       // }
        
        for specdef in translateObject.specificLanguagewordDefLists
        {
            print(specdef)
        }
        for specdef in translateObject.specificLanguagewordType
        {
            print(specdef)
        }

        self.meaningVC.MeaningTableVCTranslateObj = translateObject
        self.view.addSubview(self.meaningVC.view)
        
// self.specificLanguageHorizontalView = LDAHorizontalScrollOptionView(view, titleValues: ["Stu dents","Calendar","Score","4","5"], atYValue: 0, withHeight: 45, displayItem: 3)
      self.specificLanguageHorizontalView.selectedColor = UIColor.white
        self.specificLanguageHorizontalView.textColor = UIColor.white
        
       var specArr =  [String]()
        
        for item in translateObject.specificLanguagewordDefLists
        {
            for object in item{
                specArr.append(object.ESWordDefinition)
            
            }
            break
        }
     
        self.specificLanguageHorizontalView.setup(titleValues: specArr, withHeight: 30, displayItem: 3)
        self.specificLanguageHorizontalView.selectedColor = UIColor.white
        self.specificLanguageHorizontalView.textColor = UIColor.white

        
        
        
        self.setupConstraints()
        self.view.layoutIfNeeded()
        
        print(self.meaningVC.view.frame)
        
        
        //  UIApplication.shared.keyWindow?.addSubview(MeaningTableViewController.sharedInstance.view)
        //  UIApplication.shared.keyWindow?.bringSubview(toFront: (MeaningTableViewController.sharedInstance.view)!)
        ESAnimation.shareInstance.bringViewToFrontAndBlurBackground(view: (self.view)!, widthOffset: 2.0, height: frame.size.height)
        
        // MeaningTableViewController.sharedInstance.view.frame =  frame
        
        
        
        // viewController.view.addSubview((MeaningTableViewController.sharedInstance.view)!)
        // viewController.view.bringSubview(toFront: (MeaningTableViewController.sharedInstance.view)!)
        
        
        if   MeaningTableViewController.sharedInstance.MeaningTableVCTranslateObj != nil
        {
            print( MeaningTableViewController.sharedInstance)
            if  MeaningTableViewController.sharedInstance == nil
            {
                
            }
            self.meaningVC.tableView.reloadData()
            //  self.tableView.reloadData()
        } 
        
    }

}

class MeaningTableViewController: UITableViewController {


    //static var sharedInstance = UIStoryboard(name: "MeaningTableViewStoryboard", bundle: nil).instantiateViewController(withIdentifier: "MainTableViewController") as! MeaningTableViewController

    let kCloseCellHeight: CGFloat = 100
    let kOpenCellHeight: CGFloat = 300.0

    let kRowsCount = 10
    
    var cellHeights = [CGFloat]()
    var currentExploringWord:String?
    var MeaningTableVCTranslateObj:ESTranslateObject?
     static var sharedInstance = MeaningTableViewController()
    var meaningVC :  MeaningTableViewController?
    func displayMeaningofWordTo(frame:CGRect,translateObject:ESTranslateObject)
    {
        
     //   let storyboard = UIStoryboard(name: "MeaningTableViewStoryboard", bundle: nil)
      
        
      //  MeaningTableViewController.sharedInstance = storyboard.instantiateViewController(withIdentifier: "MainTableViewController") as! MeaningTableViewController
        self.meaningVC = nil
        
        if meaningVC == nil
        {
        self.meaningVC =  UIStoryboard(name: "MeaningTableViewStoryboard", bundle: nil).instantiateViewController(withIdentifier: "MainTableViewController") as! MeaningTableViewController
        
    
        }
       self.meaningVC?.MeaningTableVCTranslateObj = translateObject
      //  UIApplication.shared.keyWindow?.addSubview(MeaningTableViewController.sharedInstance.view)
       //  UIApplication.shared.keyWindow?.bringSubview(toFront: (MeaningTableViewController.sharedInstance.view)!)
            ESAnimation.shareInstance.bringViewToFrontAndBlurBackground(view: (self.meaningVC?.tableView)!, widthOffset: 2.0, height: frame.size.height)
        
       // MeaningTableViewController.sharedInstance.view.frame =  frame
        

        
        // viewController.view.addSubview((MeaningTableViewController.sharedInstance.view)!)
       // viewController.view.bringSubview(toFront: (MeaningTableViewController.sharedInstance.view)!)
        
        
        if   MeaningTableViewController.sharedInstance.MeaningTableVCTranslateObj != nil
        {
            print( MeaningTableViewController.sharedInstance)
            if  MeaningTableViewController.sharedInstance == nil
            {
                
            }
            self.meaningVC?.tableView.reloadData()
          //  self.tableView.reloadData()
        } 
        
    }
 
    func titleText()
    {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        label.text = self.currentExploringWord
        self.view.addSubview(label)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
self.titleText()
        createCellHeightsArray()
        self.tableView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        
        //self.view.layer.cornerRadius = 8.0
        //self.view.layer.masksToBounds = true
                       // timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: Selector("doSomething"), userInfo: nil, repeats: false)
    }
    
    // MARK: configure
    func createCellHeightsArray() {
        for _ in 0...kRowsCount {
            cellHeights.append(kCloseCellHeight)
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        
        return (MeaningTableVCTranslateObj?.getTotalObject())! 
        return (MeaningTableVCTranslateObj?.wordDefLists.count)!
        return 10
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
      
      guard case let cell as MeaningCell = cell else {
        return
      }
      
      cell.backgroundColor = UIColor.clear
      
      if cellHeights[(indexPath as NSIndexPath).row] == kCloseCellHeight {
        cell.selectedAnimation(false, animated: false, completion:nil)
      } else {
        cell.selectedAnimation(true, animated: false, completion: nil)
      }
      
      cell.number = indexPath.row
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! MeaningCell
        
        cell.setDataFromTranlateObject(translateObject:  self.MeaningTableVCTranslateObj!, cellIndex: indexPath.row)
        cell.layoutIfNeeded()
            print(cell.frame)
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
               /*
        let cell =  tableView.cellForRow(at: indexPath) as! MeaningCell
        
        if cell.MeaningCell_FrontWordDefinitionLabel != nil
        {
   return  EnglishSocietyVCShareFunctions.SharedInstance.heightForView(cell.MeaningCell_FrontWordDefinitionLabel.text!, font: cell.MeaningCell_FrontWordDefinitionLabel.font, width: cell.MeaningCell_FrontWordDefinitionLabel.frame.width)
            
        }
 */
        return (self.cellHeights[(indexPath as NSIndexPath).row])
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        
        
        if cell.isAnimating() {
            return
        }
 
    
        

    
    var duration = 0.0
    if cellHeights[(indexPath as NSIndexPath).row] == kCloseCellHeight { // open cell
    cellHeights[(indexPath as NSIndexPath).row] = CGFloat(kOpenCellHeight)
    cell.setBackViewHeight(newHeight: CGFloat(kOpenCellHeight))
    
        
        
        
        
        let cellx =  tableView.cellForRow(at: indexPath) as! MeaningCell
        
        if cellx.MeaningCell_FrontWordDefinitionLabel != nil
        {
           var height = EnglishSocietyVCShareFunctions.SharedInstance.heightForView(cellx.MeaningCellBackWorDefinitionLabel.text!, font: cellx.MeaningCellBackWorDefinitionLabel.font, width: cellx.MeaningCellBackWorDefinitionLabel.frame.width)
            
            height += EnglishSocietyVCShareFunctions.SharedInstance.heightForView(cellx.MeaningCellBackWordSynonymLabel.text!, font: cellx.MeaningCellBackWordSynonymLabel.font, width: cellx.MeaningCellBackWordSynonymLabel.frame.width)
            
              height += EnglishSocietyVCShareFunctions.SharedInstance.heightForView(cellx.MeaningCellBackWordExampleLabel.text!, font: cellx.MeaningCellBackWordExampleLabel.font, width: cellx.MeaningCellBackWordExampleLabel.frame.width)
            
            
            print(height)
            //default is 120
             cellHeights[(indexPath as NSIndexPath).row] = CGFloat(135 + height)
             cell.setBackViewHeight(newHeight: CGFloat(135 + height))
        }

        
        
        
    cell.selectedAnimation(true, animated: true, completion: nil)
    duration = 0.5
    } else {// close cell
    cellHeights[(indexPath as NSIndexPath).row] = kCloseCellHeight

    cell.selectedAnimation(false, animated: true, completion: nil)
        cell.setBackViewHeight(newHeight: kCloseCellHeight)
    duration = 0.8
    }

    /*
        var duration = 0.0
        if cellHeights[(indexPath as NSIndexPath).row] == kCloseCellHeight { // open cell
            cellHeights[(indexPath as NSIndexPath).row] = CGFloat(self.kOpenCellHeight)
            cell.setBackViewHeight(newHeight: CGFloat(self.kOpenCellHeight))

            cell.selectedAnimation(true, animated: true, completion: nil)
                     duration = 0.5
        } else {// close cell
            cellHeights[(indexPath as NSIndexPath).row] = kCloseCellHeight
              cell.setBackViewHeight(newHeight: kCloseCellHeight)
            cell.selectedAnimation(false, animated: true, completion: nil)
          
            duration = 0.8
        }
        */
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)

        
    }
    // MARK: Table vie delegate
   
    
}
/*
protocol UIExtensionDelegateScrollViewDelegate:UIScrollViewDelegate
{
    func scrollToBottom(_ scrollView: UIScrollView)
    
    func scrollViewDidReachLimitBound(_ scrollView: UIScrollView)
  

}

class UIExtensionDelegateScrollView:UIScrollView,UIScrollViewDelegate
    
{
    var timer = Timer()
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
       
        
        self.delegate?.scrollViewWillBeginDragging!(self)
        if (self.contentOffset.y == 0)
        {
            
            
            if self.timer != nil
            {
                self.timer.invalidate()
            }
          //  ESAnimation.shareInstance.fadeOutToAlpha(self.view, toAlpha: 0.5, withDuration: 1)
            
            timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.aupdate), userInfo: nil, repeats: false)
            
            RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        }

    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.delegate?.scrollViewDidScroll!(scrollView)
        /*
        if scrollView.contentOffset.y >= 0 && self.view.alpha != 0
        {
            
       //     ESAnimation.shareInstance.fadeIn(self.view, withDuration: 0.2)
        }
 */
        
        print(scrollView.contentOffset.y)
        print(-scrollView.contentSize.height)
        if scrollView.contentOffset.y < -150
        {
            self.timer.invalidate()
            
        //    ESAnimation.shareInstance.fadeOut(self.view, withDuration: 0.02)
            (self.delegate as! UIExtensionDelegateScrollViewDelegate).scrollViewDidReachLimitBound(self)

        }
        

    }
    
    func aupdate()
    {
        if self.contentOffset.y < -10
            
        {
           // ESAnimation.shareInstance.fadeOut(self.view, withDuration: 0.02)
        }
        else
        {
            
            (self.delegate as! UIExtensionDelegateScrollViewDelegate).scrollViewDidReachLimitBound(self)

            
           // ESAnimation.shareInstance.fadeIn(self.view, withDuration: 0.2)
        }
        
        
    }
    

 
}
*/
private var dtimer = Timer()

extension MeaningTableViewController
{
    func closeAllMeaningViews()
    {
        ESAnimation.shareInstance.fadeOut(self.view, withDuration: 0.2)
           DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
               ESAnimation.shareInstance.removeFrontViewAndBlurBackground()
            }
     
    }
   
    var timer: Timer! {
        get {
            return objc_getAssociatedObject(self, &dtimer) as? Timer
        }
        set(newValue) {
            objc_setAssociatedObject(self, &dtimer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        
        if (scrollView.contentOffset.y == 0 || scrollView.isAtBottom)
        {
            if self.timer != nil
            {
            self.timer.invalidate()
            }
            ESAnimation.shareInstance.fadeOutToAlpha(self.view, toAlpha: 0.2, withDuration: 1)
            
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: false)
            
            RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        }
        
        
    }
    func update()
    {
        if tableView.isCommitHoldTop
        {
            
        }
        if  tableView.isCommitHoldBottom
        {
            
        }
      
        if tableView.isCommitHoldTop || tableView.isCommitHoldBottom
            
        {
            //this haven't done yet
            //   self.closeAllMeaningViews()
        }
        else
        {
            
            
            
            ESAnimation.shareInstance.fadeIn(self.view, withDuration: 0.2)
        }
        
        
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        print(scrollView.contentSize.height)
       
        /*
        if scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y <= scrollView.contentSize.height && self.view.alpha != 0
        {
            //becuase of this 
            ESAnimation.shareInstance.fadeIn(self.view, withDuration: 0.2)
        }
         */
        
        print(scrollView.isExceedTop)
        print(scrollView.isExceedBottom)
     
 
        if !scrollView.isExceedTop && !scrollView.isExceedBottom && self.view.alpha != 0
        {
       
            ESAnimation.shareInstance.fadeIn(self.view, withDuration: 0.2)
        }
        
        
        
        print(scrollView.contentOffset.y)
        print(scrollView.contentSize.height)
        print( scrollView.contentSize.height - scrollView.frame.size.height)
        if scrollView.didExceedTopWithMaxValue(value: 130) || scrollView.didExceedBottomWithMaxValue(value: 130)
        {
            self.timer.invalidate()
            
            
            
            self.closeAllMeaningViews()
            

        }
        /*
        if scrollView.contentOffset.y < -150 || scrollView.contentOffset.y > scrollView.contentSize.height + 150
        {
            self.timer.invalidate()
         
            
               self.closeAllMeaningViews()
            
        }
        
         */
    }

}


fileprivate var  commitHoldValue:CGFloat = 80.0


extension UIScrollView {
        var isExceedTop: Bool {
        return contentOffset.y < verticalOffsetForTop
    }
    func didExceedTopWithMaxValue(value:CGFloat)->Bool
    {
        
        
        return self.contentOffset.y < verticalOffsetForTop - value
    }
   
    var isExceedBottom: Bool {
        
        if self.contentSize.height - self.frame.size.height < 0
        {
            return self.contentOffset.y > 0
        }
        return self.contentOffset.y > self.contentSize.height - self.frame.size.height

    }
    var isCommitHoldBottom: Bool {
        
        if self.contentSize.height - self.frame.size.height < 0
        {
            return self.contentOffset.y > 0 + commitHoldValue
        }
        return self.contentOffset.y > self.contentSize.height - self.frame.size.height + commitHoldValue
        
    }
    var isCommitHoldTop: Bool {
        
        return contentOffset.y < verticalOffsetForTop - commitHoldValue
    }

    func didExceedBottomWithMaxValue(value:CGFloat)->Bool
    {
        
        if self.contentSize.height - self.frame.size.height < 0
        {
            return self.contentOffset.y > value
        }
        return self.contentOffset.y > self.contentSize.height - self.frame.size.height + value
        
    }

    var isAtTop: Bool {
        return contentOffset.y <= verticalOffsetForTop
    }
    
    var isAtBottom: Bool {
        if self.contentSize.height - self.frame.size.height < 0
        {
            return self.contentOffset.y >= 0
        }
        return self.contentOffset.y >= self.contentSize.height - self.frame.size.height

    }
    
    var verticalOffsetForTop: CGFloat {
        let topInset = contentInset.top
        return -topInset
    }
    
    var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }
    
}

