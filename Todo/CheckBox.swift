//
//  CheckBox.swift
//  Todo
//
//  Created by Damodar Shenoy on 6/4/18.
//  Copyright © 2018 itscoderslife. All rights reserved.
//

import UIKit

class CheckBox: UIButton {
    var isDone: Bool {
        didSet {
            
        }
    }
    
    func addCheckBox(view: UIView) {
        let viewBounds = view.bounds
        let checkBoxPath = UIBezierPath(roundedRect: CGRect(x: viewBounds.origin.x+10,
                                                            y: viewBounds.origin.y+10,
                                                            width: viewBounds.size.width-20,
                                                            height: viewBounds.size.height-20),
                                        cornerRadius: 5.0)
        
        let checkBoxLayer = CAShapeLayer()
        checkBoxLayer.fillColor = UIColor.clear.cgColor
        checkBoxLayer.strokeColor = UIColor.darkGray.cgColor
        checkBoxLayer.lineWidth = 2
        checkBoxLayer.path = checkBoxPath.cgPath
        view.layer.addSublayer(checkBoxLayer)
    }
    
    var tickMarkLayer: CAShapeLayer!
    func markDone(view: UIView, isDone: Bool) {
        
        if(!isDone && tickMarkLayer != nil) {
            tickMarkLayer.removeFromSuperlayer()
            tickMarkLayer = nil
            return
        }
        
        let viewBounds = view.bounds
        // Tick mark
        let startPoint: CGPoint = CGPoint(x: viewBounds.origin.x+10+5, y: viewBounds.origin.y+10+14)
        let midPoint: CGPoint = CGPoint(x: viewBounds.origin.x+10+10, y: viewBounds.origin.y+10+18)
        let endPoint: CGPoint = CGPoint(x: viewBounds.origin.x+10+18, y: viewBounds.origin.x+10+5)
        
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: midPoint)
        path.addLine(to: endPoint)
        
        self.tickMarkLayer = CAShapeLayer()
        tickMarkLayer.fillColor = UIColor.clear.cgColor
        tickMarkLayer.strokeColor = UIColor.darkGray.cgColor
        tickMarkLayer.lineWidth = 2
        tickMarkLayer.path = path.cgPath
        view.layer.addSublayer(tickMarkLayer)
    }
    
    
    
}
