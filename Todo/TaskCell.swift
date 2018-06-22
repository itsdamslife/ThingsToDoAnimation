//
//  TaskCell.swift
//  Todo
//
//  Created by Damodar Shenoy on 6/4/18.
//  Copyright © 2018 itscoderslife. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet var checkBox: CheckBox!
    @IBOutlet var taskTitle: UILabel!
    
    var task: Task! {
        didSet {
            self.taskTitle.text = self.task.title
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func checkboxTapped(_ sender: Any) {
        let btn: UIButton = sender as! UIButton
        btn.isSelected = !btn.isSelected
        task.isDone = btn.isSelected
    }
}
