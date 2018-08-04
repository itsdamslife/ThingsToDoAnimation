//
//  CheckBox.swift
//  Todo
//
//  Created by Damodar Shenoy on 6/4/18.
//  Copyright © 2018 itscoderslife. All rights reserved.
//

import UIKit
import os.log

class CheckBox: UIButton {
    
    //  TODO: Make the following variables IBDesignable
    let cornerRadius: CGFloat = 5.0
    let animationOffset: CGFloat = 5.0
    let animationDuration: CFTimeInterval = 0.3
    
    // fill color
    @IBInspectable var fillColor: UIColor  = UIColor.red

    // tick mark color
    @IBInspectable var tickMarkColor: UIColor  = UIColor.blue

    // border thickness
    @IBInspectable var borderThickness: CGFloat = 1.0 {
        didSet {
            checkboxLyr.lineWidth = borderThickness
            checkboxLyr.displayIfNeeded()
        }
    }

    // border color
    @IBInspectable var borderColor: UIColor  = UIColor.darkGray {
        didSet {
            checkboxLyr.strokeColor = self.borderColor.cgColor
            checkboxLyr.displayIfNeeded()
        }
    }

    private var checkBoxLayer: CAShapeLayer!
    private var tickMarkLayer: CAShapeLayer!

    private var checkBoxPathBig: UIBezierPath!
    private var checkBoxPathSmall: UIBezierPath!
    private var checkboxFrame: CGRect! {
        didSet {
            checkBoxPathBig = UIBezierPath(roundedRect: CGRect(x: checkboxFrame.origin.x-animationOffset,
                                                               y: checkboxFrame.origin.y-animationOffset,
                                                               width: checkboxFrame.size.width+(animationOffset*2),
                                                               height: checkboxFrame.size.height+(animationOffset*2)),
                                           cornerRadius: cornerRadius)
            checkBoxPathSmall = UIBezierPath(roundedRect: checkboxFrame, cornerRadius: cornerRadius)
        }
    }
    
    let checkboxLyr = CAShapeLayer()
    override var frame: CGRect {
        didSet {

            let viewBounds: CGRect = self.bounds
            checkboxFrame = CGRect(x: viewBounds.origin.x+animationOffset,
                                   y: viewBounds.origin.y+animationOffset,
                                   width: viewBounds.size.width-(animationOffset*2),
                                   height: viewBounds.size.height-(animationOffset*2))

            let checkBoxPath = UIBezierPath(roundedRect: checkboxFrame,
                                            cornerRadius: cornerRadius)

            checkboxLyr.fillColor = UIColor.clear.cgColor
            checkboxLyr.strokeColor = self.borderColor.cgColor
            checkboxLyr.lineWidth = borderThickness
            checkboxLyr.path = checkBoxPath.cgPath

            // self.layer does not have any layers
            guard let sublayers = self.layer.sublayers else {
                self.layer.addSublayer(checkboxLyr)
                return
            }

            // sublayers != nil then check if it contains checkboxLyr layer already
            if !sublayers.contains(checkboxLyr) {
                self.layer.addSublayer(checkboxLyr)
            }
        }
    }
    
    init(with frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        os_log("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            if(!isSelected && tickMarkLayer != nil) {
                self.uncheckAnimation()
                return
            }
            checkAnimation()
        }
    }
    
    func checkAnimation() {
        // Create layers if not available
        if(self.checkBoxLayer == nil) {
            checkBoxLayer = CAShapeLayer()
            checkBoxLayer.fillColor = self.fillColor.cgColor
            checkBoxLayer.path = checkBoxPathSmall.cgPath
            
            self.layer.addSublayer(checkBoxLayer)
        }
        
        // Tick mark
        let x = checkboxFrame.origin.x
        let y = checkboxFrame.origin.y
        let w = checkboxFrame.size.width
        let h = checkboxFrame.size.height

        
        let startPoint: CGPoint = CGPoint(x: x+(w*0.20), y: y+(h*0.60))
        let midPoint: CGPoint = CGPoint(x: x+(w*0.40), y: y+(h*0.80))
        let endPoint: CGPoint = CGPoint(x: x+(w*0.80), y: y+(h*0.30))
        
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: midPoint)
        path.addLine(to: endPoint)
        
        self.tickMarkLayer = CAShapeLayer()
        tickMarkLayer.fillColor = UIColor.clear.cgColor
        tickMarkLayer.strokeColor = self.tickMarkColor.cgColor
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
            
            self.layer.addSublayer(self.tickMarkLayer)
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

    
    
}
