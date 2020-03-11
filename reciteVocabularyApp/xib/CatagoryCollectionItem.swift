//
//  CatagoryCollectionItem.swift
//  reciteVocabularyApp
//
//  Created by Richard Chui on 2020/2/27.
//  Copyright © 2020 Richard Technology (Shezhen)  Co., Ltd. All rights reserved.
//

import Cocoa

class CatagoryCollectionItem: NSCollectionViewItem {

  
    @IBOutlet weak var sizeLabel: NSTextField!
    @IBOutlet weak var button: NSButton!
    @IBOutlet weak var label: NSTextField!
    var success: ((Int)->Void)?
    
    var buttonText: String? {
        didSet {
            self.button.stringValue = buttonText!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override var representedObject: Any? {
        didSet {
            if let data = self.representedObject as? NSDictionary {
                if let title = data["title"] as? String {
                    self.label.stringValue = title
                    
                }
                if let button = data["button"] as? String {
                    self.button.title = button
                }
                if let tag = (data["tag"] as? Int) {
                    self.button.tag = tag
                }
                
            }
        }
    }
    
    @IBAction func buttonAction(_ sender: NSButton) {
        success!(sender.tag)
    }
    
}
