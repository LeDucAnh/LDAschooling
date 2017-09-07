//
//  LDACalendarView.swift
//  LDAContactApp
//
//  Created by Mac on 4/24/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit



extension UIColor
{
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }

}

class LDAShowOnlyCalendarView:LDACalendarView
{
    
    override func xibSetup() {
        super.xibSetup()
        self.calendarCollectionView.calendarDelegate =  self
    
    }
    var didSelectCellAction:((_ calendar: JTAppleCalendarView, _ date: Date, _ cell: JTAppleCell?, _ cellState: CellState)->Void)!
    
    func registerForDidSelectCellAction(action:@escaping (_ calendar: JTAppleCalendarView, _ date: Date, _ cell: JTAppleCell?, _ cellState: CellState)->Void)
        
    {
        self.didSelectCellAction = action
    }

    override func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {

        self.didSelectCellAction(calendar,date,cell,cellState)
    }
    
    override func handleCellTextColor(cell: JTAppleCell?,cellState:CellState)
    {
        guard let validCell = cell as? LDACalendarCollectionViewCell else
        {
            return
        }
        
        if cellState.isSelected
        {
            validCell.calendarDateLabel.textColor = self.selectedMonthColor
            
        }
        else
        {
            if cellState.dateBelongsTo == .thisMonth
            {
                validCell.calendarDateLabel.textColor = self.selectedMonthColor
            }
            else
            {
                validCell.calendarDateLabel.textColor =  self.outsideMonthColor
            }
        }
        
        
        for item in DayArray
        {
            if Calendar.current.isDate(item, inSameDayAs: cellState.date)
            {
                if cellState.dateBelongsTo == .thisMonth
                {

                validCell.calendarDateLabel.textColor = self.selectedMonthColor
                }
            }
        }
        
    }
 override  func handleCellSelected(cell: JTAppleCell?,cellState:CellState)
    {
        guard let validCell = cell as? LDACalendarCollectionViewCell else
        {
            return
        }
        validCell.calendarSelectedView.isHidden = true
        
        for item in DayArray
        {
            if Calendar.current.isDate(item, inSameDayAs: cellState.date)
            {
                
                if cellState.dateBelongsTo == .thisMonth
                {

                validCell.calendarSelectedView.isHidden = false
                }
                
            }
        }

        
    }

}
class LDACalendarView: UIView,JTAppleCalendarViewDelegate {

    var DayArray = [Date]()

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
  //  let selectedMonthColor = UIColor(rgb: 0x584a66)
    //let outsideMonthColor = UIColor(rgb: 0x3a294b)
    
    
    let selectedMonthColor = UIColor.white
    let outsideMonthColor = UIColor(rgb: 0x584a66)
    
    @IBOutlet weak var calendarMonthLabel: UILabel!
    @IBOutlet weak var calendarYearLabel: UILabel!
    let formatter = DateFormatter()
 var view: UIView!
    @IBOutlet weak var calendarCollectionView: JTAppleCalendarView!
    static var shareInstance = LDACalendarView()
    
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
    
    func xibSetup() {
       // calendarCollectionView.calendarDelegate = self
        
     //   calendarCollectionView.calendarDataSource =  self
        
        view = loadViewFromNib()
      //  view.backgroundColor = UIColor.clear
        // Make the view stretch with containing view
        
        
        view.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        //view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
        

        print(calendarCollectionView)
        
        calendarCollectionView.register(UINib(nibName: "LDACalendarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "calendarCell")
    calendarCollectionView.allowsMultipleSelection =  true
        setupCalendarDate()
    }
    
    
    
    
    func setupCalendarDate()
    {
        self.calendarCollectionView.visibleDates { (DateSegmentInfo) in
            let date  = DateSegmentInfo.monthDates.first!.date
            self.formatter.dateFormat = "yyyy"
            
            
            self.calendarYearLabel.text = self.formatter.string(from: date)
            
            self.formatter.dateFormat = "MMMM"
            self.calendarMonthLabel.text = self.formatter.string(from: date)

        }

        

    }
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "LDACalendarView", bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
   func handleCellTextColor(cell: JTAppleCell?,cellState:CellState)
    {
        guard let validCell = cell as? LDACalendarCollectionViewCell else
        {
            return
        }
        
        if cellState.isSelected
        {
            validCell.calendarDateLabel.textColor = self.selectedMonthColor
            
        }
        else
        {
            if cellState.dateBelongsTo == .thisMonth
            {
                validCell.calendarDateLabel.textColor = self.selectedMonthColor
            }
            else
            {
                validCell.calendarDateLabel.textColor =  self.outsideMonthColor
            }
        }

    }
    func handleCellSelected(cell: JTAppleCell?,cellState:CellState)
    {
        guard let validCell = cell as? LDACalendarCollectionViewCell else
        {
            return
        }
        
        if cellState.isSelected
        {
        validCell.calendarSelectedView.isHidden = false
            
        
        }
        else
        {validCell.calendarSelectedView.isHidden = true
            
        }

    }
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        self.handleCellSelected(cell: cell, cellState: cellState)
        self.handleCellTextColor(cell: cell, cellState: cellState)
    }
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        
        
        self.setupCalendarDate()
        
    }
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        self.handleCellSelected(cell: cell, cellState: cellState)
        self.handleCellTextColor(cell: cell, cellState: cellState)
        
    }


    
}
extension LDACalendarView : JTAppleCalendarViewDataSource
{
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2017 1 1")
        let endDate = formatter.date(from: "2017 12 31")
        return  ConfigurationParameters(startDate: startDate!, endDate: endDate!)
        
    }
     func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        let cell =  calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "calendarCell", for: indexPath) as! LDACalendarCollectionViewCell
      //  cell.backgroundColor = EnglishSocietyConfigurateVaribles.SharedInstance.ESGymOrange
       // cell.layer.cornerRadius = 8.0
        //cell.layer.masksToBounds = true
        
            cell.calendarDateLabel.text = cellState.text
        
        
        
        self.handleCellSelected(cell: cell, cellState: cellState)
        self.handleCellTextColor(cell: cell, cellState: cellState)
        return cell
     }
    
    
}
extension LDACalendarView
{
    
}
