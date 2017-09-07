//
//  LDACANotificationViewController.swift
//  LDAContactApp
//
//  Created by Mac on 6/25/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit



class LDACANotificationViewController: UIViewController, ZYThumbnailTableViewControllerDelegate, DiyTopViewDelegate  {
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    func topViewDidClickShareBtn(_ topView: TopView) {
        
        
        
        if topViewDidClickShareBtnAction != nil
        {
        topViewDidClickShareBtnAction(topView)
        }

        let indexPath = topView.indexPath
        self.dataList.removeObject(at: (indexPath?.row)!)
        
        self.zyThumbnailTableVC.reloadMainTableView()
        
        
        
    }
    
    var topViewDidClickShareBtnAction:((_ topView: TopView)->Void)!
    
    func registertopViewDidClickShareBtn(action:@escaping (_ topView: TopView)->Void)
    {
        self.topViewDidClickShareBtnAction = action
        
    }

    
    var cellReturnAction:((_ atCell:DIYTableViewCell,_ type:DIYTableViewCellActionReturnType,_ value : [String:Any])->Void)!
    
    func registercellReturnAction(action:@escaping (_ atCell:DIYTableViewCell,_ type:DIYTableViewCellActionReturnType,_ value : [String:Any])->Void)
    {
        self.cellReturnAction = action
        
    }
    func registerStatusButtonReturn(action:@escaping (_ noti:LDACANotification)->Void)
    {
        self.StatusButtonReturn = action
        
    }
    var StatusButtonReturn:((_ noti:LDACANotification)->Void)!
    


    
    
    var zyThumbnailTableVC: ZYThumbnailTableViewController!
    var dataList = NSMutableArray()
    func insertAtIndex(noti:LDACANotification,index:Int)
    {
   self.dataList.insert(noti, at: index)
    self.zyThumbnailTableVC.tableViewDataList = dataList
    self.zyThumbnailTableVC.reloadMainTableView()

   // self.zyThumbnailTableVC.refreshView()

    }
    func addNewNoti(noti:LDACANotification)
    {
        //self.dataList.addObjects(from: [noti])
        self.dataList.addObjects(from: [noti])
        self.zyThumbnailTableVC.tableViewDataList = dataList
        
        
        
        
        self.zyThumbnailTableVC.reloadMainTableView()
       // self.zyThumbnailTableVC.refreshView()
    }
    func setNoti(noti:[LDACANotification])
    {
        self.dataList = noti as! NSMutableArray
        self.zyThumbnailTableVC.tableViewDataList = dataList
        self.zyThumbnailTableVC.reloadMainTableView()
      //  self.zyThumbnailTableVC.refreshView()

        
    }
    func updateNoti(noti:LDACANotification)
    {
        
        var index = -1
        for item  in self.dataList
        {
            if (item as! LDACANotification).parent == noti.parent
            {
                index = self.dataList.index(of: item)
            }
            
            
        }
        print(index)
        if index != -1
        {
            
            
            print(index)
            if self.dataList.count != 0
            {
                //self.dataList.insert(noti, at: index)
               
              //  self.dataList.removeObject(at: index + 1)
                self.dataList.replaceObject(at: index, with: noti)
                self.zyThumbnailTableVC.tableViewDataList = dataList
                  self.zyThumbnailTableVC.reloadMainTableView()
                
                /*
                if self.topviewArray.count != 0
                {
                    self.topviewArray[0].configureComponents(noti)
                }
 */
                
                if self.topviewValue != nil
                {
                    self.topviewValue.configureComponents(noti)
                }
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNav()
        configureZYTableView()
        self.addzyThumbnailTableVC()
    }
    
    
    func addzyThumbnailTableVC()
    {
        if !self.view.subviews.contains(zyThumbnailTableVC.view)
        {
            self.view.addSubview(zyThumbnailTableVC.view)
            zyThumbnailTableVC.view.frame = self.view.frame
        }
        
    }
    var topviewValue  :   LDACANotiTableViewCellTopView!
    
    func configureNav() {
        self.navigationController?.navigationBar.isTranslucent = false
        let titleView = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        titleView.text = "ZYThumbnailTabelView"
        titleView.textAlignment = .center
        titleView.font = UIFont.systemFont(ofSize: 20.0);
        //503f39
        titleView.textColor = UIColor(red: 63/255.0, green: 47/255.0, blue: 41/255.0, alpha: 1.0)
        self.navigationItem.titleView = titleView
        
        let barItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.done, target: nil, action: nil)
        self.navigationController?.navigationBar.tintColor = UIColor.gray
        self.navigationItem.backBarButtonItem = barItem
    }
    func configureZYTableView() {
        zyThumbnailTableVC = ZYThumbnailTableViewController()
        zyThumbnailTableVC.tableViewCellReuseId = "DIYTableViewCell"
        //right here
        zyThumbnailTableVC.tableViewCellHeight = 100.0
        
        //模拟创建一些数据作为演示
        //getFirebaseNotiXXX
        
        
        
        //--------configure your diy tableview cell datalist
        zyThumbnailTableVC.tableViewDataList = dataList
        
        //--------insert your diy tableview cell
        zyThumbnailTableVC.configureTableViewCellBlock = {
            
            return DIYTableViewCell.createCell()
            // cell.videoView.removeFromSuperview()
            
        }
        zyThumbnailTableVC.ConfigureTableViewPreviewCellBlock =
            { [weak self](cell: UITableViewCell, indexPath: IndexPath) -> DIYTableViewCell in
                
                
                guard let dataSource = self?.zyThumbnailTableVC.tableViewDataList[(indexPath as NSIndexPath).row] as? LDACANotification else {
                    return DIYTableViewCell.createPreviewCell()
                }
                
                let cell =  DIYTableViewCell.createPreviewCell()
                cell.isPreviewCell = true
                cell.avatarImageView.image = (self?.zyThumbnailTableVC.tableViewDataList[(indexPath as NSIndexPath).row] as! LDACANotification).sendUser?.profileimage
                
                
                
                return cell
                
        }
        //--------update your cell here
        zyThumbnailTableVC.updateTableViewCellBlock =  { [weak self](cell: UITableViewCell, indexPath: IndexPath) -> Void in
            let myCell = cell as? DIYTableViewCell
            //Post is my data model
            guard let dataSource = self?.zyThumbnailTableVC.tableViewDataList[(indexPath as NSIndexPath).row] as? LDACANotification else {
                print("ERROR: illegal tableview dataSource")
                return
            }
            myCell?.registerForReturnAction {(actionType)  in
               
                
                
                if actionType.rawValue == DIYTableViewCellActionReturnType.DetailButtonTapped.rawValue
                {
                    self?.cellReturnAction(myCell!,actionType,["":""])
                    
                    
                }
                if actionType.rawValue == DIYTableViewCellActionReturnType.URLWebViewTapped.rawValue
                {

                self?.cellReturnAction(myCell!,actionType,["url":dataSource.embedURL])

              
                }
                
            }
            
            myCell?.updateCell(dataSource)
            
            
            
            myCell?.avatarImageView.sd_setImage(with: URL(string: (dataSource.sendUser?.profileImageURL)!), completed: { (UIImage, Error, SDImageCacheType, URL) in
                
                ESAnimation.shareInstance.executeGradientBorderAnimationFor(view: (myCell?.avatarImageView)!, colors: [UIColor.yellow.cgColor,UIColor.red.cgColor,UIColor.orange.cgColor])
                
                
                
                (self?.zyThumbnailTableVC.tableViewDataList[(indexPath as NSIndexPath).row] as! LDACANotification).sendUser?.profileimage = UIImage
                
            })
            
            
        }
        
        
        //--------insert your diy TopView
        zyThumbnailTableVC.createTopExpansionViewBlock = { [weak self](indexPath: IndexPath) -> UIView in
            //Post is my data model
            let post = self?.zyThumbnailTableVC.tableViewDataList[(indexPath as NSIndexPath).row] as! LDACANotification
            let topView = LDACANotiTableViewCellTopView.createView(indexPath, post: post)!
            topView.delegate = self;
            topView.configureComponents(post)
            //self?.topviewArray.append(topView as! LDACANotiTableViewCellTopView)
            self?.topviewValue = topView as! LDACANotiTableViewCellTopView
            
            return topView
        }
        
        let diyBottomView = BottomView.createView()!
        //--------let your inputView component not cover by keyboard automatically (animated) (ZYKeyboardUtil)
        //全自动键盘遮盖处理
        zyThumbnailTableVC.keyboardAdaptiveView = diyBottomView.inputTextField;
        //--------insert your diy BottomView
        zyThumbnailTableVC.createBottomExpansionViewBlock = { _ in
            return diyBottomView
        }
        
        configureZYTableViewNav()
    }
    func configureZYTableViewNav() {
        let titleView = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        titleView.text = "ZYThumbnailTabelView"
        titleView.textAlignment = .center
        titleView.font = UIFont.systemFont(ofSize: 20.0);
        //503f39
        titleView.textColor = UIColor(red: 63/255.0, green: 47/255.0, blue: 41/255.0, alpha: 1.0)
        zyThumbnailTableVC.navigationItem.titleView = titleView
    }
    
    @IBAction func clickEnterButton(_ sender: UIButton) {
        self.navigationController?.pushViewController(zyThumbnailTableVC, animated: true)
    }
    
    //MARK: delegate
    func zyTableViewDidSelectRow(_ tableView: UITableView, indexPath: IndexPath) {
    }
    
    func topViewDidClickFavoriteBtn(_ topView: TopView) {
        let indexPath = topView.indexPath
        //Post is my data model
       // let post = zyThumbnailTableVC.tableViewDataList[(indexPath?.row)!] as! LDACANotification
        // zyThumbnailTableVC.reloadMainTableView()
        
        //
//     let videoview = ESVideoWatchingViewController()
        
  //      self.present(videoview, animated: true, completion: nil)
        
    }
    
    func topViewDidClickMarkAsReadButton(_ topView: TopView) {
        let indexPath = topView.indexPath
        let post = zyThumbnailTableVC.tableViewDataList[(indexPath?.row)!] as! LDACANotification
        //post.read = !post.read
        if StatusButtonReturn !=  nil
        {
            self.StatusButtonReturn(post)
        
        }
        
        zyThumbnailTableVC.reloadMainTableView()
    }
    
    //此方法作用是虚拟出tableview数据源，不用理会
    //MARK: -Virtual DataSource for Demo
    /*
     func createDataSource() -> NSArray {
     let dataSource = NSMutableArray()
     let content = "The lesson of the story, I suggested, was that in some strange sense we are more whole when we are missing something. \n    The man who has everything is in some ways a poor man. \n    He will never know what it feels like to yearn, to hope, to nourish his soul with the dream of something better. \n    He will never know the experience of having someone who loves him give him something he has always wanted or never had."
     
     dataSource.add([
     "name" : "NURGIO",
     "avatar" : "avatar0",
     "desc" : "Beijing,Chaoyang District",
     "time" : "3 minute",
     "content" : content,
     "favorite" : false,
     "read" : true
     ])
     
     dataSource.add([
     "name" : "Cheers",
     "avatar" : "avatar1",
     "desc" : "Joined on Dec 18, 2014",
     "time" : "8 minute",
     "content": "You know that you do not need to be in the limelight to gain happiness. If you constantly aim to be in the spotlight, you are looking to others for validation. \n    In actuality, you should just be yourself. People do not like characters that are always in your line of vision and trying to gain your attention.\n    You know that you can just be yourself with others, without the need to be in the limelight. \n    People will see you as a beautiful girl when you are being you, not trying to persistently have all attention on you. \n    Who can have a real conversation with someone who is eagerly looking around and making sure all eyes are on them?",
     "favorite" : false,
     "read" : true
     ])
     
     dataSource.add([
     "name" : "Adleys",
     "avatar" : "avatar2",
     "desc" : "The Technology Studio",
     "time" : "16 minute",
     "content": "To each parent he responded with one line: \"Are you going to help me now?\" \n    And then he continued to dig for his son, stone by stone. \n    The fire chief showed up and tried to pull him off the school s ruins saying, \"Fires are breaking out, explosions are happening everywhere. \n    You’re in danger. We’ll take care of it. Go home.\" To which this loving, caring American father asked, \"Are you going to help me now?\"",
     "favorite" : false,
     "read" : false
     ])
     
     dataSource.add([
     "name" : "Coder_CYX",
     "avatar" : "avatar3",
     "desc" : "Joined on Mar 26, 2013",
     "time" : "21 minute",
     "content": "One year after our \"talk,\" I discovered I had breast cancer. I was thirty-two, the mother of three beautiful young children, and scared. \n    The cancer had metastasized to my lymph nodes and the statistics were not great for long-term survival. \n    After my surgery, friends and loved ones visited and tried to find the right words. No one knew what to say, and many said the wrong things. \n    Others wept, and I tried to encourage them. I clung to hope myself.",
     "favorite" : true,
     "read" : false
     ])
     
     dataSource.add([
     "name" : "Coleman",
     "avatar" : "avatar4",
     "desc" : "Zhejiang University of Technology",
     "time" : "28 minute",
     "content": "You don’t let others hold you back from being yourself. To many people, showing your real face to others is terrifying. But you are always yourself.\n    You don’t let others opinions scare you into being someone else. Instead you choose to be you, flaws and all. You are truly a beautiful girl if you possess this quality. \n    People can often sense when you are being fake, or notice if you are reserved and afraid to speak. To be able to be yourself is inspiring and beautiful, because you are putting yourself out there (without fear).",
     "favorite" : false,
     "read" : false
     ])
     
     dataSource.add([
     "name" : "Moguilay",
     "avatar" : "avatar5",
     "desc" : "zbien.com",
     "time" : "33 minute",
     "content": content,
     "favorite" : false,
     "read" : false
     ])
     
     dataSource.add([
     "name" : "Dikey",
     "avatar" : "avatar6",
     "desc" : "Pluto at the moment",
     "time" : "35 minute",
     "content": content,
     "favorite" : false,
     "read" : false
     ])
     
     dataSource.add([
     "name" : "fmricky",
     "avatar" : "avatar7",
     "desc" : "Waterloo, ON",
     "time" : "42 minute",
     "content": content,
     "favorite" : false,
     "read" : false
     ])
     
     dataSource.add([
     "name" : "Robert Waggott",
     "avatar" : "avatar8",
     "desc" : "Beijing chaoyang",
     "time" : "46 minute",
     "content": content,
     "favorite" : false,
     "read" : false
     ])
     
     //source dict to model
     let sourceDict = NSArray(array: dataSource)
     let postArray = NSMutableArray()
     for dict in sourceDict {
     let post = LDACANotification()
     let handleDict = dict as! Dictionary<String, AnyObject>
     post.name =  validStringForKeyFromDictionary("name", dict: handleDict)
     post.desc = validStringForKeyFromDictionary("desc", dict: handleDict)
     post.time = validStringForKeyFromDictionary("time", dict: handleDict)
     post.content = validStringForKeyFromDictionary("content", dict: handleDict)
     post.avatar = validStringForKeyFromDictionary("avatar", dict: handleDict)
     post.favorite = handleDict["favorite"] as? Bool ?? false
     post.read = handleDict["read"] as? Bool ?? false
     postArray.add(post)
     }
     return NSArray(array: postArray)
     }
     */
    
    
    func validStringForKeyFromDictionary(_ key: String, dict: Dictionary<String, AnyObject>) -> String {
        return dict[key] as? String ?? "illegal"
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



//MARK: Model class
/*
 class Post: NSObject {
 var name: String = ""
 var avatar: String = ""
 var desc: String = ""
 var time: String = ""
 var content: String = ""
 var favorite: Bool = false
 var read: Bool = false
 override init()
 {
 
 }
 required init(noti:LDACANotification)
 {
 //    self.name = noti.
 }
 
 }
 */

