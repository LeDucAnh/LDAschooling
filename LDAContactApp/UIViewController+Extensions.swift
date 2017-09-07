//
//  UIViewController+Extensions.swift
//  LDAContactApp
//
//  Created by Mac on 5/31/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit

extension UIViewController {
    func performSegueToReturnBack()  {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

