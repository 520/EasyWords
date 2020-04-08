import Cocoa

class WindowController: NSWindowController, NSWindowDelegate {

    //searchPanel
    var topLevelArray: NSArray?
    
    
//    @IBAction func searchAction(_ sender: Any) {
//        self.myPanel?.parent = self.window
//        self.window?.beginSheet(self.myPanel!, completionHandler: { returnCode in
//            print(returnCode)
//        })
//    }
    
    @IBAction func refreshAction(_ sender: Any) {
        let vc = self.window?.contentViewController as! ViewController
        
        let table = UserDefaults.standard.object(forKey: userDefualtsCatagory)
        vc.data = DB.share.fetchTwentyData(table: table as! String)
            
            var chinese = [String]()
            var english = [String]()
            for d in vc.data {
                chinese.append(d.chinese)
                english.append(d.english)
            }
        
            UserDefaults.standard.set(english, forKey: userDefaultsEnglish)
            UserDefaults.standard.set(chinese, forKey: userDefaultsChinese)
    }
    
    @IBAction func quizAction(_ sender: Any) {

    }
    
    @IBOutlet weak var toolBar: NSToolbar!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.titleVisibility = .hidden
    }
    
    func windowWillClose(_ notification: Notification) {
        self.contentViewController = nil
        self.window = nil
    }
    
    
}


      

