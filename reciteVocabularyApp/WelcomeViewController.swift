import Cocoa

class WelcomeViewController: NSViewController {

    var mainAppWVC: NSWindowController?

    @IBOutlet weak var button: NSButton!
    @IBOutlet weak var wordLabel: NSTextField!
    @IBOutlet weak var explanationLabel: NSTextField!
    let main = gre
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    
    
    @IBAction func startAction(_ sender: Any) {
        self.storeData(table: self.main)
        self.view.window?.close()
        let sb = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        mainAppWVC = sb.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "MainAppWVC")) as? NSWindowController
        mainAppWVC?.showWindow(self)
    }
    
    
}
