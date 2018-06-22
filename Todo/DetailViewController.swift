//
//  DetailViewController.swift
//  Todo
//
//  Created by Damodar Shenoy on 6/19/18.
//  Copyright © 2018 itscoderslife. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addLeftBarItem(leftItem: .Close)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func removeLeftBarButtons(_ sender: Any) {
        self.removeLeftBarItem(showDefaultButton: false)
    }
    

}
