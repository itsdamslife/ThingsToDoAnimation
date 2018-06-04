//
//  TaskCell.swift
//  Todo
//
//  Created by Damodar Shenoy on 6/4/18.
//  Copyright © 2018 itscoderslife. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet var checkBox: UIButton!
    @IBOutlet var taskTitle: UILabel!
    
    var task: Task! {
        didSet {
            self.taskTitle.text = self.task.title
            self.addCheckBox(view: self.checkBox)
        }
    }
    
    // Animationa nd layer properties and methods
    let cornerRadius: CGFloat = 5.0
    let animationDuration: CFTimeInterval = 0.3
    var checkBoxPathBig: UIBezierPath!
    var checkBoxPathSmall: UIBezierPath!
    var checkBoxLayer: CAShapeLayer!
    var checkboxFrame: CGRect! {
        didSet {
            checkBoxPathBig = UIBezierPath(roundedRect: CGRect(x: checkboxFrame.origin.x-3,
                                                                   y: checkboxFrame.origin.y-3,
                                                                   width: checkboxFrame.size.width+3,
                                                                   height: checkboxFrame.size.height+3),
                                               cornerRadius: cornerRadius)
            checkBoxPathSmall = UIBezierPath(roundedRect: checkboxFrame, cornerRadius: cornerRadius)
        }
    }
    
    func addCheckBox(view: UIView) {
        let viewBounds = view.bounds
        checkboxFrame = CGRect(x: viewBounds.origin.x+10,
                               y: viewBounds.origin.y+10,
                               width: viewBounds.size.width-20,
                               height: viewBounds.size.height-20)
        
        let checkBoxPath = UIBezierPath(roundedRect: checkboxFrame,
                                        cornerRadius: cornerRadius)
        
        let checkboxLyr = CAShapeLayer()
        checkboxLyr.fillColor = UIColor.clear.cgColor
        checkboxLyr.strokeColor = UIColor.darkGray.cgColor
        checkboxLyr.lineWidth = 2
        checkboxLyr.path = checkBoxPath.cgPath
        view.layer.addSublayer(checkboxLyr)
    }
    
    var tickMarkLayer: CAShapeLayer!
    func markDone(view: UIView, isDone: Bool) {
        
        if(!isDone && tickMarkLayer != nil) {
            self.uncheckAnimation()
            return
        }
        
        checkAnimation()
    }
    
    func checkAnimation() {
        // Rounded rect animation
        
        // Create layers if not available
        if(self.checkBoxLayer == nil) {
            checkBoxLayer = CAShapeLayer()
            checkBoxLayer.fillColor = UIColor.blue.cgColor
            checkBoxLayer.path = checkBoxPathSmall.cgPath
            self.checkBox.layer.addSublayer(checkBoxLayer)
        }
        
        // Tick mark
        let startPoint: CGPoint = CGPoint(x: checkboxFrame.origin.x+5, y: checkboxFrame.origin.y+14)
        let midPoint: CGPoint = CGPoint(x: checkboxFrame.origin.x+10, y: checkboxFrame.origin.y+18)
        let endPoint: CGPoint = CGPoint(x: checkboxFrame.origin.x+18, y: checkboxFrame.origin.x+7)
        
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: midPoint)
        path.addLine(to: endPoint)
        
        self.tickMarkLayer = CAShapeLayer()
        tickMarkLayer.fillColor = UIColor.clear.cgColor
        tickMarkLayer.strokeColor = UIColor.white.cgColor
        tickMarkLayer.lineWidth = 1.5
        self.tickMarkLayer.lineJoin = kCALineJoinRound
        tickMarkLayer.path = path.cgPath

        let selectAnimation: CABasicAnimation = CABasicAnimation(keyPath: "path")
        selectAnimation.fromValue = checkBoxPathBig.cgPath
        selectAnimation.toValue = checkBoxPathSmall.cgPath
        selectAnimation.fillMode = kCAFillModeBoth
        selectAnimation.isRemovedOnCompletion = false
        
        // Layer fade animation
        let fadeAnim: CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnim.fromValue = 0.0
        fadeAnim.toValue = 1.0
        
        // Create a group for all the animations
        let groupAnim: CAAnimationGroup = CAAnimationGroup()
        groupAnim.duration = animationDuration
        groupAnim.repeatCount = 1
        groupAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        groupAnim.animations = [selectAnimation, fadeAnim]
        
        CATransaction.setCompletionBlock { [unowned self] in
            let pathAnimation = CABasicAnimation(keyPath:"strokeEnd")
            pathAnimation.duration = 0.1
            pathAnimation.fromValue = 0
            pathAnimation.toValue = 1
            
            self.checkBox.layer.addSublayer(self.tickMarkLayer)
            self.tickMarkLayer.add(pathAnimation, forKey: nil)
        }
        
        CATransaction.begin()
        checkBoxLayer.add(groupAnim, forKey: nil)
        CATransaction.commit()
    }
    
    func uncheckAnimation() {
        
        let selectAnimation: CABasicAnimation = CABasicAnimation(keyPath: "path")
        selectAnimation.fromValue = checkBoxPathSmall.cgPath
        selectAnimation.toValue = checkBoxPathBig.cgPath
        selectAnimation.fillMode = kCAFillModeBoth
        selectAnimation.isRemovedOnCompletion = false
        
        // Layer fade animation
        let fadeAnim: CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnim.fromValue = 1.0
        fadeAnim.toValue = 0.0
        
        // Create a group for all the animations
        let groupAnim: CAAnimationGroup = CAAnimationGroup()
        groupAnim.duration = animationDuration
        groupAnim.repeatCount = 1
        groupAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        groupAnim.animations = [selectAnimation, fadeAnim]
        
        CATransaction.setCompletionBlock { [unowned self] in
            self.checkBoxLayer.removeFromSuperlayer()
            self.checkBoxLayer = nil
            
            self.tickMarkLayer.removeFromSuperlayer()
            self.tickMarkLayer = nil
        }
        
        CATransaction.begin()
        checkBoxLayer.add(groupAnim, forKey: nil)
        CATransaction.commit()

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func checkboxTapped(_ sender: Any) {
        let btn: UIButton = sender as! UIButton
        btn.isSelected = !btn.isSelected
        task.isDone = btn.isSelected
        self.markDone(view: btn, isDone: task.isDone)
    }
}
