//
//  LDACARequestTableViewController.swift
//  LDAContactApp
//
//  Created by Mac on 6/10/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit

class LDACARequestTableViewController: UITableViewController {
    
    
    var classModel : LDACAClass!
    
    var requestArr = [LDACAClassRequest]()
    
    
     init(classmodel:LDACAClass)
    {
            super.init(style: .plain)
        self.classModel = classmodel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        

        
        
        self.tableView.register(LDACARequestTableViewCell.self, forCellReuseIdentifier: "Cell")
                self.tableView.register(UINib(nibName: "LDACARequestTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
self.tableView.separatorStyle = .none
        self.setupFirebase()
    }

    func setupFirebase()
    {
        //print(classModel.parent)
        
        /*
        LDACAClassRequest.GetLastedRequestWithSingleEvent(classID: classModel.parent!, LDACAClassRequest(), isInitialLoad: true) { (arr) in
            
            self.requestArr.append(contentsOf: arr)
            self.tableView.reloadData()

        }
 */
        LDACAClassRequest.registerAddedRequest(classID: classModel.parent!) { (arr) in
            self.requestArr.append(contentsOf: arr)
            self.tableView.reloadData()
        }

        
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if requestArr != nil
        {
            return (requestArr.count)

        }
            return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LDACARequestTableViewCell

        // Configure the cell...
        
        print(requestArr[indexPath.row])
        
    let createTimeString =     NSDate(timeIntervalSince1970: TimeInterval(requestArr[indexPath.row].timestamp)).timeAgoSinceDate(numericDates: true)
   
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        // again convert your date to string
        
        let onDateString =  formatter.string(from: Date(timeIntervalSince1970: requestArr[indexPath.row].dateTime))
        
        
      
      
        
        
        cell.RequestUserNameLabel.text = requestArr[indexPath.row].fromID! + " created " + createTimeString
        
        
        cell.RequestContentLabel.text =  "Request on \(onDateString) : " + requestArr[indexPath.row].content!
        
        cell.RequestStatusButton.setTitle(LDACAClassRequestTypeStringArr[requestArr[indexPath.row].requestType!], for: .normal)
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
