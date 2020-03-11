//
//  AppDelegate.swift
//  reciteVocabularyApp
//
//  Created by Richard Chui on 2020/2/22.
//  Copyright © 2020 Richard Technology (Shezhen)  Co., Ltd. All rights reserved.
//

import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {


    var statusItem: NSStatusItem? = nil
    var count = 0
    var isShow = false
    var number = 0

    var mainAppWVC: NSWindowController?
    
    lazy var popover: NSPopover = {
        let popoverTemp = NSPopover()
        popoverTemp.contentViewController = FlashViewController()
        return popoverTemp
    }()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
//        let domain = Bundle.main.bundleIdentifier!
//        UserDefaults.standard.removePersistentDomain(forName: domain)
//        DB.share.drop(table: oxford)
//        DB.share.drop(table: toefl)
//        DB.share.drop(table: gre)
        
        // 44716
        if DB.share.countRow(table: oxford) < 44716 {
            DB.share.drop(table: oxford)
            DispatchQueue.global().async {
                self.loadOxford()
            }
        }
        
        //2511
        if DB.share.countRow(table: toefl) < 2511 {
            DB.share.drop(table: toefl)
            DispatchQueue.global().async {
                self.loadData(toefl)
            }
        }
        
        // 7512
        if DB.share.countRow(table: gre) < 7512 {
            DB.share.drop(table: gre)
            DispatchQueue.global().async {
                self.loadData(gre)
            }
        }
        
        
        let sb = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        if let _ = UserDefaults.standard.array(forKey: userDefaultsChinese) {
            mainAppWVC = sb.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "MainAppWVC")) as? NSWindowController
        }else{
            mainAppWVC = sb.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "WelcomeWVC")) as? NSWindowController
        }
        mainAppWVC?.showWindow(self)
        
        
        self.createButtonStatusBar()
     
        
        
        //let clean = value.replacingOccurrences(of: "\\[.*\\]", with: "", options: .regularExpression)
            
    }
    
    func loadData(_ t: String) {
        UserDefaults.standard.set(t, forKey: userDefualtsCatagory)
        DB.share.create(table: t)
        let a = getRows(table: t)
        for b in a! {
            DB.share.insertDataWith(table: t, dhvalue: b.english, dhkey: b.chinese)
        }
    }
    
    func loadOxford() {
        DB.share.create(table: oxford)
            //var count = 0
        for i in 1...147 {
                
            let a = getRows(table: "\(i)")
            for b in a! {
                DB.share.insertDataWith(table: oxford, dhvalue: b.english, dhkey: b.chinese)
            }
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

    func reopen() {
        if mainAppWVC!.isWindowLoaded {
            
            //激活应用到前台(如果应用窗口处于非活动状态)
            NSRunningApplication.current.activate(options: [NSApplication.ActivationOptions.activateIgnoringOtherApps])
            let window =  NSApp.windows[0]
            window.orderFront(self)
      
        }else{
            
            if let _ = UserDefaults.standard.array(forKey: userDefaultsChinese) {
                let sb = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
                mainAppWVC = sb.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "MainAppWVC")) as? NSWindowController
                mainAppWVC?.showWindow(self)
            }
        
        }
    }
    
    
    @IBAction func reopenAction(_ sender: Any) {
        reopen()
    }
    
    
    @IBAction func rateAction(_ sender: Any) {
        let id = "1501832774"
        guard let writeReviewURL = URL(string: "macappstore://apps.apple.com/app/id\(id)?action=write-review")
                    else { fatalError("Expected a valid URL") }
        NSWorkspace.shared.open(writeReviewURL)
    }
    
    @IBAction func emailAction(_ sender: Any) {
        let service = NSSharingService(named: NSSharingService.Name.composeEmail)

        service?.recipients = ["itxu@outlook.com"]
        service?.subject = "这是我给简背的一点意见。(This is a suggestion given to EasyWords)"
        service?.perform(withItems: ["1.问题Question: \n\n\n2.意见Resolution: \n\n\n（感谢您的来信,您的意见一旦采取在下次的更新将会获取现金奖励 Thanks for your opinion, once it is accepted in next update, you will get cash reward.）"])
    }
    
    
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        reopen()
        return true
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func softwareUpdate(_ sender: Any) {
        
    }
    
}

// statusbar
extension AppDelegate {
    func createButtonStatusBar() {
        
        let date = Date().addingTimeInterval(0)
        let timer = Timer(fireAt: date, interval: 600, target: self, selector: #selector(selectorTimer), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
    
    }
    
    @objc func selectorTimer() {
        
        let statusBar = NSStatusBar.system
        let item = statusBar.statusItem(withLength: NSStatusItem.variableLength)
        item.button?.target = self
        item.button?.action = #selector(AppDelegate.statusBarAction)
        
        
        if let chinese = UserDefaults.standard.array(forKey: userDefaultsChinese),
        let english = UserDefaults.standard.array(forKey: userDefaultsEnglish) {
            if english.count == 0 { return }
            item.button?.title = "\(english[count]) \(chinese[count])"
            count = (count < 19) ? count + 1 : 0
        }else {
            item.button?.title = "Welcome n. 欢迎"
        }
        
        statusItem = item
    }
    
    @objc func statusBarAction(_ sender: NSStatusBarButton) {

        
        if !self.isShow {
            self.isShow = true
            self.popover.show(relativeTo: NSZeroRect, of: sender, preferredEdge: .minY)
        } else {
            self.popover.close()
            self.isShow = false
        }
        
    }
    
    
}



// toolbar
extension AppDelegate {
    //    func algorithem(table: String) -> [(chinese: String, english: String)]? {
    //        var result = [(chinese: String, english: String)]()
    //        let bundle = Bundle.main.url(forResource: table, withExtension: "txt")!
    //        //let url = NSURL(fileURLWithPath: urlStr)
    //        guard let string = try? NSString.init(contentsOf: bundle, encoding: String.Encoding.utf8.rawValue) else { return nil }
    //        let a = (string as String).removeEmptyLine
    //        let b = a.split(separator: "\n")
    //        let count = b.count
    //        for c in b {
    //            let d = c.trimmingCharacters(in: .whitespaces)
    //            let e = d.split(separator: " ")
    //            if e.count>1 {
    //                if e[0].isChinese {
    //                    result.append((chinese: String(e[0]), english: String(e[1])))
    //                }else{
    //                    result.append((chinese: String(e[1]), english: String(e[0])))
    //                }
    //            }else{
    //                var isChinese = 0
    //                var index = 0
    //                for (key, value) in d.enumerated() {
    //                    if ("\u{4E00}" <= value  && value <= "\u{9FA5}") {
    //                        let temp = 1
    //                        if temp + isChinese == 0 {
    //                            index = key
    //                            break
    //                        }else{
    //                            isChinese = 1
    //                        }
    //                    }else{
    //                        isChinese = -1
    //                    }
    //                }
    //                let o = d.prefix(index)
    //                let p = d.suffix(d.count - index)
    //                if o.isChinese {
    //                    result.append((chinese: String(o), english: String(p)))
    //                }else{
    //                    result.append((chinese: String(p), english: String(o)))
    //                }
    //
    //            }
    //
    //        }
    //        return result
    //    }
    //
}
