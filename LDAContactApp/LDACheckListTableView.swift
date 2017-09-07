//
//  LDACheckListTableView.swift
//  LDAContactApp
//
//  Created by Mac on 5/18/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit

public enum LDACheckListTableViewCellStatus : Int {
    case selected
    case notselected
}
class LDACheckListTableView: UITableView  ,UITableViewDelegate{
/*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

     func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let more = UITableViewRowAction(style: .normal, title: "Select All") { action, index in
            print("more button tapped")
            self.isAllSelected =  true

            
            
          
            
        }
        more.backgroundColor = UIColor.lightGray
        
        let favorite = UITableViewRowAction(style: .normal, title: "Deselect All") { action, index in
            print("favorite button tapped")
            self.isAllSelected =  false

        }
        favorite.backgroundColor = UIColor.orange
        
                return [ favorite, more]

    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
    }
    
    var isAllSelected : Bool?
    {
        didSet{
            
            if self.isAllSelected == true
            {
                self.SelectedAllRow()
                
            }
            else
            {
                self.DeselectedAllRow()
                
            }
            // println("didSet called")
        }
        willSet(newValue){
            //println("willSet called")
        }
    }
    func SelectedAllRow()
    {
        
        var i = 0
        for item in self.cellStatusArr
        {
            //   item =  LDACheckListTableViewCellStatus.selected
            cellStatusArr[i] = LDACheckListTableViewCellStatus.selected
            i += 1
        }
        
        self.reloadRows(at: self.indexPathsForVisibleRows!, with: .fade)
        
    }
    func DeselectedAllRow()
    {
        var i = 0
        for item in self.cellStatusArr
        {
            //   item =  LDACheckListTableViewCellStatus.selected
            cellStatusArr[i] = LDACheckListTableViewCellStatus.notselected
            i += 1
        }
        
        
        self.reloadRows(at: self.indexPathsForVisibleRows!, with: .fade)

        
    }

    var cellStatusArr = [LDACheckListTableViewCellStatus]()
    
    func setup(numberOfItem:Int)
    {
        cellStatusArr.removeAll()
        self.delegate =  self
        var i = 0
        while i < numberOfItem{
            
            cellStatusArr.append(LDACheckListTableViewCellStatus.notselected)
            
            i += 1
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       if cellStatusArr[indexPath.row] == .selected
       {
                cellStatusArr[indexPath.row] = .notselected
        }
        else
       {
        cellStatusArr[indexPath.row] = .selected
        }
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    

}

/*
 
class LDACheckHandler
{
  static  let cellSelectedImage = UIImage(named: "import")
   static let cellNonSelectedImage = UIImage(named: "teacher")
    
   static var selectedImageView = UIImageView()
  class func embedIntoTableViewCell(status : LDACheckListTableViewCellStatus,cell:UITableViewCell)
    {
        if !cell.subviews.contains(selectedImageView)
        {
            selectedImageView = UIImageView(image: cellNonSelectedImage)
            selectedImageView.translatesAutoresizingMaskIntoConstraints = false
            cell.addSubview(selectedImageView)
            selectedImageView.anchor(cell.topAnchor, left: nil, bottom: cell.bottomAnchor, right: cell.rightAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 2, rightConstant: 2, widthConstant: 45, heightConstant: 45)
            cell.layoutIfNeeded()
            cell.layoutSubviews()
            selectedImageView.tag = -1
        }
        
        
        if status == .selected{
            selectedImageView.image = cellSelectedImage
        }
        else
        {
            selectedImageView.image = cellNonSelectedImage
        }
        
    }
}
 */


class LDAStudentCheckListTableView : LDACheckListTableView,UITableViewDataSource
 {
    
    
    
    
    
    



    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentIDArr.count

    }

    func isAllSelected()-> Bool
    {
        
        if self.StudentIDArr.count == self.countSelectedRow()
        {
        return true
        }
        return false
    }
    func countSelectedRow() -> Int
    {
        print(String(cellStatusArr.filter({$0 == LDACheckListTableViewCellStatus.selected}).count))
      
        
        let selectecArr = cellStatusArr.filter({$0 == LDACheckListTableViewCellStatus.selected})
    
        return  selectecArr.count
    }
    var StudentIDArr = [Int]()
    //0---
    /*
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
    }
     required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
 */
    //---
    init(frame : CGRect ,Items : [Int] )
    {
        super.init(frame: frame, style: .plain)
        self.StudentIDArr = Items
        self.setup(numberOfItem: Items.count)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setup(numberOfItem :Int)
    {
        super.setup(numberOfItem: numberOfItem)
        self.register(LDAUserIDTableViewCell.self, forCellReuseIdentifier: "Cell")
        
        self.register(UINib(nibName: "LDAUserIDTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        
        self.dataSource =  self
        self.reloadData()
    
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell =  self.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LDAUserIDTableViewCell
        
        cell.UserIDTtileLabel.text = String(self.StudentIDArr[indexPath.row])
        cell.UserIDTtileLabel.textColor  = UIColor.white
        cell.UserIDTtileLabel?.backgroundColor = EnglishSocietyConfigurateVaribles.SharedInstance.randColor()
        
                var image  = UIImage(named: "close")?.withRenderingMode(.alwaysTemplate)
        if self.cellStatusArr[indexPath.row] == .selected
        {
             image  = UIImage(named: "send")?.withRenderingMode(.alwaysTemplate)
        }
        

        cell.UserDetailButton.setImage(image, for: .normal)
        cell.UserDetailButton.imageView?.tintColor = EnglishSocietyConfigurateVaribles.SharedInstance.ESGymRed
        
       // LDACheckHandler.embedIntoTableViewCell(status: self.cellStatusArr[indexPath.row], cell: cell)
        
        cell.captureDetailButtontouchAction {
            
            //do something in here
        }
            return cell
    }
}

