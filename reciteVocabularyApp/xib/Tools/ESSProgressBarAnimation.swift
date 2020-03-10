//
//  ESSProgressBarAnimation.swift
//  reciteVocabularyApp
//
//  Created by Richard Chui on 2020/2/26.
//  Copyright © 2020 Richard Technology (Shezhen)  Co., Ltd. All rights reserved.
//

import Foundation
import Cocoa

class ESSProgressBarAnimation : NSAnimation
{
    let indicator : NSProgressIndicator
    let initialValue : Double
    let newValue : Double
    
    init(_ progressIndicator: NSProgressIndicator, newValue: Double)
    {
        self.indicator = progressIndicator
        self.initialValue = progressIndicator.doubleValue
        self.newValue = newValue
        
        super.init(duration: 0.2, animationCurve: .linear)
        self.animationBlockingMode = .nonblockingThreaded
    }

    required init?(coder aDecoder: NSCoder) {
        
        indicator = NSProgressIndicator()
        initialValue = 0
        newValue = 0
        
        super.init(coder: aDecoder)
    }
    
    override var currentProgress : NSAnimation.Progress
    {
        didSet {
            let delta = self.newValue - self.initialValue
            
            self.indicator.doubleValue = self.initialValue + (delta * Double(currentProgress))
        }
    }
}

extension NSProgressIndicator
{
    func animateToDoubleValue(value: Double)
    {
        let animation = ESSProgressBarAnimation(self, newValue: value)
        animation.start()
        //return animation
    }
}
