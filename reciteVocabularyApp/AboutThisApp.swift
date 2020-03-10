//
//  AboutThisApp.swift
//  reciteVocabularyApp
//
//  Created by Richard Chui on 2020/2/23.
//  Copyright © 2020 Richard Technology (Shezhen)  Co., Ltd. All rights reserved.
//

import Cocoa

class AboutThisApp: NSViewController {

    @IBOutlet weak var indicator: NSProgressIndicator!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "About This App"
    }
    
    @IBAction func updateAction(_ sender: NSButton) {
        self.indicator.startAnimation(self)
        sender.title = "Checking Update"
    }
}
