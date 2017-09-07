//
//  LDACAClassRequestSendFormViewController.swift
//  LDAContactApp
//
//  Created by Mac on 6/10/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit



class LDACAClassRequestSendFormViewController: UIViewController {
    @IBOutlet weak var requestLabel: UILabel!
    @IBOutlet weak var requestTextField: UITextField!

    var request : LDACAClassRequest!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.requestTextField.placeholder = LDACAClassRequestTypeStringDescriptionArr[request.requestType!]
        self.requestLabel.text = LDACAClassRequestTypeStringArr[request.requestType!]

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
