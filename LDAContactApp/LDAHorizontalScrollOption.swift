//
//  LDAHorizontalScrollOption.swift
//  LDAContactApp
//
//  Created by Mac on 5/4/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit


public enum LDAHorizontalScrollOptionCellState
{
    case selected
    case nonselected
}
protocol LDAHorizontalScrollOptionCellDelegate
{
    func celldidSelected(cell:LDAHorizontalScrollOptionCell)
    
    func celldidDeSelected(cell:LDAHorizontalScrollOptionCell)
    
}
@IBDesignable class LDAHorizontalScrollOptionCell:UIView
{
    
    var deSelectedAlpha = 0.5
    var originalSize = CGSize()
    var titleTextColor = UIColor.white
    var titleLabel = UILabel()
    var titleString :String?
    var selectionView = UIView(frame: CGRect.zero)
    var state: LDAHorizontalScrollOptionCellState = .nonselected
    var delegate  : LDAHorizontalScrollOptionCellDelegate?
    
    var nonselectedFont = UIFont.systemFont(ofSize: 12)
    var selectedFont = UIFont.boldSystemFont(ofSize: 18)
    
    var selectedColor = UIColor.white
    
    init(optionTitle:String,cellSize:CGSize) {
        
        super.init(frame: CGRect(x: 0, y: 0, width: cellSize.width, height: cellSize.height))
        titleString  =  optionTitle
        self.originalSize =  cellSize
        self.setup()
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
      //  fatalError("init(coder:) has not been implemented")
    }
    func setup()
    {
        self.titleLabel.textAlignment = .center
        self.titleLabel.numberOfLines = 0
        self.selectionView.frame = CGRect(x: 0, y: self.frame.size.height - 4, width: self.frame.size.width, height: 4)
        
        selectionView.backgroundColor = selectedColor
        self.addSubview(self.selectionView)
        
        self.titleLabel.text = self.titleString
        titleLabel.textAlignment = .center
        self.titleLabel.textColor = self.titleTextColor
        
        
        let yValue = self.frame.size.height -  22 - 4
        
        
        self.titleLabel.frame = CGRect(x: 8, y: yValue, width: self.frame.size.width - 16, height: 22)
        print(self.titleLabel.frame)
        self.titleLabel.font = nonselectedFont
        //self.titleLabel.backgroundColor = UIColor.blue
        self.addSubview(self.titleLabel)
        
        self.setupGesture()
        
    }
    func setupGesture()
        
    {
        
        
        let tap = UITapGestureRecognizer(target: self, action:#selector(self.handleTap(sender:)))
        tap.numberOfTapsRequired  = 1
        // tap.delegate =  self
        self.addGestureRecognizer(tap)
    }
    
    func setSelected()
    {
        if self.state == .nonselected
        {
            
            print(self.titleLabel.frame.size)
            print(self.frame.size)
            
            var selectedWidth =   (self.titleLabel.text?.width(withConstrainedHeight: self.titleLabel.frame.size.height, font: self.selectedFont))! + 24.0
            
            if selectedWidth < self.originalSize.width
            {
                selectedWidth = self.originalSize.width
            }
            
            self.state = .selected
            
            self.selectionView.frame.origin.y += 2
            
            self.titleLabel.font = selectedFont
            
            UIView.animate(withDuration: 0.2, animations: {
                self.selectionView.frame.size.height -= 2
                
                self.updateCellToWidth(width: selectedWidth)
                self.titleLabel.alpha = 1
                print(self.frame.size.width)
            })
            
            if self.delegate != nil {
                self.delegate?.celldidSelected(cell: self)
            }
            
        }
        
    }
    func setDeselected()
    {
        if self.state == .selected
        {
            self.state =  .nonselected
            self.selectionView.frame.size.height += 2
            
            self.titleLabel.font = nonselectedFont
            UIView.animate(withDuration: 0.2, animations: {
                self.selectionView.frame.origin.y -= 2
                self.updateCellToWidth(width: self.originalSize.width)
                self.titleLabel.alpha = CGFloat(self.deSelectedAlpha)
            })
            
            if self.delegate != nil {
                self.delegate?.celldidDeSelected(cell: self)
            }
            
        }
        
    }
    func updateCellToWidth(width :CGFloat)
    {
        self.frame.size.width = width
        self.titleLabel.frame.size.width = width
        self.selectionView.frame.size.width = self.frame.size.width
        self.selectionView.frame.origin.x = 0
        
        
        print(self.selectionView.frame)
        print(self.titleLabel.frame)
        
    }
    func handleTap(sender: AnyObject? = nil) {
        // handling code
        
        if self.state == .nonselected
        {
            self.setSelected()
            self.layoutSubviews()
            self.layoutIfNeeded()
        }
        else
        {
            //self.setDeselected()
        }
        //self.delegate?.LDAOptionButtonViewDidTouch(sender: self)
    }
    
    
}
protocol LDAHorizontalScrollOptionViewDelegate
{
    func didSelectCell(cell:LDAHorizontalScrollOptionCell)
}
@IBDesignable class LDAHorizontalScrollOptionView: UIScrollView,UIScrollViewDelegate,LDAHorizontalScrollOptionCellDelegate {
    
    var displayItem :Int = 3
    // MARK: - view init
    var selectedColor = UIColor.white
    
    var currentOption:Int?
    
    var textColor : UIColor?
    {
        didSet{
            for item in  self.items
            {
                item.titleTextColor = self.textColor!
                item.titleLabel.textColor = self.textColor
            }
            // println("didSet called")
        }
        willSet(newValue){
            //println("willSet called")
        }
    }
    
    
    var items  = [LDAHorizontalScrollOptionCell]()
    
    private var selectedCellAction:((_ cell:LDAHorizontalScrollOptionCell)->Void)!
    
    
    func setSelectedAtIndex(index:Int)
    {
    
    items[index].setSelected()
    }
    func registerForCellSelected(action:@escaping (_ cell:LDAHorizontalScrollOptionCell)->Void)
    {
        self.selectedCellAction = action
    }
    func checkValidCenter(_ xValue:CGFloat)-> Bool
    {
      //  if xValue + self.frame.size.width > self.contentSize.width || xValue < 0
        if xValue < 0
            
        {
            return false
        }
        return true
    }
    func centerScrollview(_ selectedCell:LDAHorizontalScrollOptionCell)
    {
        if self.displayItem >= 3
        {
            if self.selectedCellAction != nil{
                
                self.selectedCellAction(selectedCell)
            }
            var xValue =  self.itemSize.width * CGFloat(selectedCell.tag) - CGFloat(self.displayItem/2) * (self.itemSize.width)
            
            if xValue + self.frame.size.width > self.contentSize.width
            {
                //adjust xValue
                xValue = self.itemSize.width * CGFloat(selectedCell.tag - 1)
            }
            if xValue < 0
            

            {
                self.itemSize.width * CGFloat(selectedCell.tag)
                
            }
            
            if self.checkValidCenter(xValue)
            {
                self.scrollRectToVisible(CGRect(x: xValue, y: 0, width: 1, height: 1), animated: true)
                // or
                self.setContentOffset(CGPoint(x: xValue, y: 0), animated: true)
            }
        }
        
        
        
    }
    
    
    func celldidSelected(cell: LDAHorizontalScrollOptionCell) {
        
        
        self.currentOption =  cell.tag

        self.centerScrollview(cell)
        
        
        for item in self.items
        {
            if item !=  cell{
                item.setDeselected()
            }
        }
                self.reArrangeSubItem()
        
        
    }
    func celldidDeSelected(cell: LDAHorizontalScrollOptionCell) {
        
        self.reArrangeSubItem()
        
    }
    
    var itemSize = CGSize(width: 0, height: 0)
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    fileprivate func initView() {
        //default item size is 80% of height
        //    self.uniformItemSize = CGSize(width: frame.size.height*0.8, height: frame.size.height*0.8)
        
        self.showsHorizontalScrollIndicator = false
        self.isPagingEnabled =  true
        self.decelerationRate = UIScrollViewDecelerationRateFast
        
        self.delegate = self
    }
    func setup(titleValues: [String] ,withHeight:CGFloat = 60, displayItem:Int = 3)
    {
        self.items.removeAll()
        
        for subview in self.subviews
        {
            subview.removeFromSuperview()
        }
        
        
        var displayItem = displayItem
        if displayItem < 3
        {
            displayItem = 3
        }
        
        if displayItem % 2 == 0
        {
            displayItem += 1
        }
        initView()
        
        
        if let displaynumber = displayItem as? Int
        {
            self.displayItem =  displaynumber
        }
        
        var itemWidth = self.frame.size.width/CGFloat(displayItem)
        
        
        
        self.itemSize = CGSize(width: itemWidth, height: withHeight)
        
        //self.embedToView(view: toView)
        
        
        //set up item
        var i = 0
        for string in titleValues
        {
            let item  = LDAHorizontalScrollOptionCell(optionTitle: string, cellSize: self.itemSize)
            //  item.backgroundColor = UIColor.brown
            self.addItem(item)
            item.selectedColor =  self.selectedColor
            item.tag = i
            i += 1
        }
        print(self.items.count)
        
        
        print(self.frame)
    }
    init(_ toView : UIView,titleValues: [String] ,atYValue:CGFloat,withHeight:CGFloat = 60, displayItem:Int = 3) {
        
        super.init(frame: CGRect(x: 0, y: atYValue, width: toView.frame.size.width, height: withHeight))
        self.setup(titleValues: titleValues, withHeight: withHeight, displayItem: displayItem)
        if !toView.subviews.contains(self)
        {
            toView.addSubview(self)
        }
    }
    open func addItem(_ item:LDAHorizontalScrollOptionCell)
    {
        
        
        
        items.append(item)
        item.delegate = self
        
        
        self.setItem(item)
        
        
        self.addSubview(item)
        // set the content size of scroll view to fit new width and with the same margin as left margin
        //    self.contentSize = CGSize(width: item.frame.origin.x + self.uniformItemSize.width + self.leftMarginPx, height: self.frame.size.height);
        
        
        let width = CGFloat(self.items.count) * self.itemSize.width
        
        print(self.items.count)
        print(self.itemSize.width)
        
        print(width)
        self.contentSize = CGSize(width: width, height: self.frame.height)
    }
    func setItem(_ item:LDAHorizontalScrollOptionCell)
    {
        let xValue = itemSize.width * CGFloat(items.index(of: item)!)
        
        item.frame.origin = CGPoint(x: xValue, y: 0)
        
        
        
    }
    func reArrangeSubItem()
    {
        print(self.items.count)
        print(self.subviews.count)
        
        
        for subitem in self.items
        {
            //  subitem.frame.origin.x = CGFloat(i) * self.itemSize.width
            // i += 1
            self.setItem(subitem)
        }
        
        
        
        var offset:CGFloat = 0.0
        for subitem in self.items
        {
            
            if offset != 0.0
            {
                subitem.frame.origin = CGPoint(x: subitem.frame.origin.x + offset, y: subitem.frame.origin.y)
            }
            if subitem.frame.size.width > self.itemSize.width
            {
                offset += subitem.frame.size.width - self.itemSize.width
            }
            
            
            
        }
        let width = CGFloat(self.items.count) * self.itemSize.width + offset
        
        self.contentSize = CGSize(width: width, height: self.frame.height)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0  || scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y  = 0
        }
        
    }
    
    
    
    
}
//down below is an example for usage in playground

/*
 //view
 
 let view = UIView()
 view.backgroundColor = UIColor.white
 
 view.frame.size = CGSize(width: 320, height: 1024)
 
 
 var optionView = LDAHorizontalScrollOptionView(view, titleValues: ["A","b","C","d","e"], atYValue: 0)
 //var optionView = LDAHorizontalScrollOptionView(view, atYValue: 0, withHeight: 60, displayItem: 3)
 //optionView.backgroundColor = UIColor.green
 
 
 PlaygroundPage.current.liveView = view
 
 PlaygroundPage.current.needsIndefiniteExecution = true
 */

