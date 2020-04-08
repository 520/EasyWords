import Cocoa

class FlashViewController: NSViewController {

    @IBOutlet weak var chineseLabel: NSTextField!
    @IBOutlet weak var englishLabel: NSTextField!
    
    var index = 0
    var set: [(chinese: String, english: String)]?
    var timer: Timer?
    var silent = true
    var second: Double {
        get {
            if let s = UserDefaults.standard.object(forKey: "FlashSecond") {
                return s as! Double
            }else{
                return 2
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "FlashSecond")
        }
    }
    
    override func viewWillAppear() {
        loop(every: second)
    }
    
    override func viewWillDisappear() {
        timer?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let c = UserDefaults.standard.array(forKey: userDefaultsChinese),
            let e = UserDefaults.standard.array(forKey: userDefaultsEnglish) {
            chineseLabel.stringValue = c[5] as! String
            englishLabel.stringValue = e[5] as! String
        }
        let date = Date().addingTimeInterval(0)
        timer = Timer(fireAt: date, interval: second, target: self, selector: #selector(selectorTimer), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
        
    }
    
    @objc func selectorTimer() {
        let table = UserDefaults.standard.object(forKey: userDefualtsCatagory)
        if let set = set {
            chineseLabel.stringValue = set[index].chinese
            englishLabel.stringValue = set[index].english
            if !silent {
                let speak = Speak()
                speak.play(set[index].english)
            }
            index = index<19 ? index + 1 : 0
            if index < 19 {
                index += 1
            }else{
                index = 0
                self.set = DB.share.fetchTwentyData(table: table as! String)
            }
        }else{
            set = DB.share.fetchTwentyData(table: table as! String)
        }
        
        
    }
    
    @IBAction func secondAction(_ sender: NSButton) {
        let t = sender.title
        var s: Double = 2
        switch t {
        case "1s":
            sender.title = "2s"
        case "2s":
            sender.title = "3s"
            s = 3
        case "3s":
            sender.title = "5s"
            s = 5
        case "5s":
            sender.title = "1s"
        default:
            break
        }
        second = s
        loop(every: s)
    }
    
    func loop(every: Double) {
        timer?.invalidate()
        let date = Date().addingTimeInterval(0)
        timer = Timer(fireAt: date, interval: TimeInterval(every), target: self, selector: #selector(selectorTimer), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
    }
    
    @IBAction func silentAction(_ sender: NSButton) {
        if sender.tag == 0 {
            sender.image = NSImage(imageLiteralResourceName: "NSTouchBarAudioOutputVolumeLowTemplate")
            sender.tag = 1
            silent = false
        }else{
            sender.image = NSImage(imageLiteralResourceName: "NSTouchBarAudioOutputMuteTemplate")
            sender.tag = 0
            silent = true
        }
    }
    
}
