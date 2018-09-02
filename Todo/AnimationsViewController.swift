//
//  AnimationsViewController.swift
//  Todo
//
//  Created by Damodar Shenoy on 06/08/18.
//  Copyright © 2018 itscoderslife. All rights reserved.
//

import UIKit


class AnimationsViewController: UIViewController {

    @IBOutlet weak var checkboxContainer: UIStackView!
    @IBOutlet weak var checkBox: CheckBox!
    @IBOutlet weak var checkBoxLabel: UILabel!
    @IBOutlet weak var cbContainerCenterConstraint: NSLayoutConstraint!


    let funcDict : [String: String] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        checkBox.backgroundColor = .clear
        checkBoxLabel.backgroundColor = .clear
        view.backgroundColor = .yellow
        checkBox.isSelected = true

        checkBox.alpha = 0.0
        checkBoxLabel.alpha = 0.0
        checkboxContainer.alpha = 0.0

        let str = "criticalFunc:"
        perform(Selector((str)), with: "⭕️")
    }
    
    @objc func criticalFunc(_ object: String) {
        print("Critical executed! \(object)")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let str = "successFunc:"
        perform(Selector((str)), with: "✅")
    }

    @objc func successFunc(_ object: String) {
        print("Success executed! \(object)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: 1.0, animations: { [unowned self] in
            self.checkboxContainer.alpha = 1.0
        })

        UIView.animate(withDuration: 1.0, delay: 2.0, options: [.curveEaseOut], animations: { [unowned self] in
            self.checkBox.alpha = 1.0
        }, completion: nil)

        UIView.animate(withDuration: 1.0, delay: 3.0, options: [.curveEaseOut], animations: { [unowned self] in
            self.checkBoxLabel.alpha = 1.0
        }, completion: { [unowned self] finished in
            guard finished else { return }
            UIView.animate(withDuration: 1.0, animations: { [unowned self] in
                self.view.backgroundColor = .white
            }, completion: { [unowned self] _ in
                UIView.animate(withDuration: 1.0, delay: 0.5,
                               usingSpringWithDamping: 0.3, initialSpringVelocity: 0.6,
                               options: [.curveEaseOut], animations: { [unowned self] in
                    var frame = self.checkboxContainer.frame
                    frame.origin.y -= 50
                    self.checkboxContainer.frame = frame
                }, completion: nil)
            })
        })

    }

    @IBAction func checkboxTapped(_ sender: Any) {
        let btn: UIButton = sender as! UIButton
        btn.isSelected = !btn.isSelected
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
