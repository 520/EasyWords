//
//  WelcomeViewController.swift
//  简背
//
//  Created by Richard Chui on 2020/3/3.
//  Copyright © 2020 Richard Technology (Shezhen)  Co., Ltd. All rights reserved.
//

import Cocoa

class WelcomeViewController: NSViewController {

    var mainAppWVC: NSWindowController?

    @IBOutlet weak var button: NSButton!
    @IBOutlet weak var wordLabel: NSTextField!
    @IBOutlet weak var explanationLabel: NSTextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global().async {
            self.loadData([toefl,cet4])
        }
        
        self.wordLabel.alphaValue = 0
        self.button.alphaValue = 0
        self.explanationLabel.alphaValue = 0
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 2
            self.wordLabel.animator().setFrameOrigin(NSPoint(x: self.wordLabel.frame.origin.x, y: self.wordLabel.frame.origin.y - 10))
            self.wordLabel.animator().alphaValue = 1
        },completionHandler: {
            
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 2
                self.explanationLabel.animator().setFrameOrigin(NSPoint(x: self.explanationLabel.frame.origin.x, y: self.explanationLabel.frame.origin.y - 10))
                self.explanationLabel.animator().alphaValue = 1
            },completionHandler: {
                
                NSAnimationContext.runAnimationGroup({ context in
                    context.duration = 2
                    self.button.animator().setFrameOrigin(NSPoint(x: self.button.frame.origin.x, y: self.button.frame.origin.y - 10))
                    self.button.animator().alphaValue = 1
                },completionHandler: {
                    
                })
                
            })
            
        })
        
        
        
    }
    
    func storeData(table: String) {
            
        let data = DB.share.fetchTwentyData(table: table)
        var chinese = [String]()
        var english = [String]()
        for d in data {
            chinese.append(d.chinese)
            english.append(d.english)
        }
            
        UserDefaults.standard.set(english, forKey: userDefaultsEnglish)
        UserDefaults.standard.set(chinese, forKey: userDefaultsChinese)
    }
    
    
    func loadData(_ table: [String]) {
        
        UserDefaults.standard.set(table[0], forKey: userDefualtsCatagory)
        
        
        for t in table {
        if DB.share.isEmpty(table: t) {
            DB.share.create(table: t)
            let a = getRows(table: t)
            for b in a! {
                DB.share.insertDataWith(table: t, dhvalue: b.english, dhkey: b.chinese)
            }
                
            storeData(table: table[0])
            print("cet loaded")
        }
        }
        
        if DB.share.isEmpty(table: oxford) {
            DB.share.create(table: oxford)
            //var count = 0
            for i in 1...147 {
                
                let a = getRows(table: "\(i)")
                for b in a! {
                    DB.share.insertDataWith(table: oxford, dhvalue: b.english, dhkey: b.chinese)
                }
                print(i)
            }
            UserDefaults.standard.set(true, forKey: userDefaultsOxfordDone)
        }
        
        DispatchQueue.main.async {
            self.button.isHidden = false
            self.wordLabel.stringValue = "Welcome"
            self.explanationLabel.stringValue = "n. 欢迎"
        }
        
    }
    
    func getRows(table: String) -> [(chinese: String, english: String)]? {
        var result = [(chinese: String, english: String)]()
        var temp = (chinese: "", english: "")
        let bundle = Bundle.main.url(forResource: table, withExtension: "txt")!
        //let url = NSURL(fileURLWithPath: urlStr)
        guard let string = try? NSString.init(contentsOf: bundle, encoding: String.Encoding.utf8.rawValue) else { return nil }
        let a = (string as String).removeEmptyLine
        let b = a.split(separator: "\n")
        for (index, value) in b.enumerated() {
            if index % 2 == 0 {
                if temp.chinese != "" {
                    result.append(temp)
                }
                temp.english = String(value)
            }else{
                temp.chinese = String(value)
            }
        }
        return result
    }
    
    @IBAction func startAction(_ sender: Any) {
        self.view.window?.close()
        let sb = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        mainAppWVC = sb.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "MainAppWVC")) as? NSWindowController
        mainAppWVC?.showWindow(self)
    }
    
    
}
