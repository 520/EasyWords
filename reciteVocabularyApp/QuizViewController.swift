import Cocoa

let notificationQuiz = Notification.Name(rawValue: "notificationQuiz")
enum enumQuiz { case on, off }

class QuizViewController: NSViewController {
    
    var current = 0 {
        didSet {
            reload(to: current)
        }
    }
    
    var sequence: [Int]!
    
    var english = [String]()
    var chinese = [String]()
    
    @IBOutlet weak var box: NSBox!
    @IBOutlet weak var bravoLabel: NSTextField!
    @IBOutlet weak var progress: NSTextField!
    @IBOutlet weak var textField: NSButton!
    @IBOutlet weak var buttonA: NSButton!
    @IBOutlet weak var buttonB: NSButton!
    @IBOutlet weak var buttonC: NSButton!
    @IBOutlet weak var buttonD: NSButton!
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func textFieldAction(_ sender: NSButton) {
        let speak = Speak()
        speak.play(sender.title)
    }
    
    @IBAction func restartAction(_ sender: Any) {
        current = 0
        bravoLabel.isHidden = true
        box.isHidden = false
        textField.isHidden = false
    }
    
    override func viewDidAppear() {
        //progressIndicator.do
        
        var arr = [Int]()
        for i in 0..<20 {
            arr.append(i)
        }
        sequence = shuffleArray(arr: shuffleArray(arr: arr))
        
        
        NotificationCenter.default.post(name: notificationQuiz, object: enumQuiz.on)
        
        
        chinese = UserDefaults.standard.array(forKey: userDefaultsChinese) as! [String]
        english = UserDefaults.standard.array(forKey: userDefaultsEnglish) as! [String]
        
        reload(to: 0)
    }
    
    override func viewDidDisappear() {
        NotificationCenter.default.post(name: notificationQuiz, object: enumQuiz.off)
    }
    
    @IBAction func boxAction(_ sender: NSButton) {
        let title = sender.title
        if title == chinese[sequence[current]] {
            sender.contentTintColor = .systemGreen
            sender.isEnabled = false
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5, execute: {
                self.current += 1
                sender.isEnabled = true
            })
            
        }else{
            let animation = CAKeyframeAnimation(keyPath: "position.x")
            animation.isAdditive = true
            animation.values = [ (-5), (5), (-4), (4), (-3), (3), (-2), (2)]
            animation.duration = 0.5
            sender.layer?.add(animation, forKey: nil)
            
            sender.contentTintColor = .systemRed
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5, execute: {
                sender.contentTintColor = .none
            })
        }
    }
    
    func reload(to i: Int) {
        
        progressIndicator.animateToDoubleValue(value: Double(100/20*current))
        
        if i >= 20 {
            
            box.isHidden = true
            textField.isHidden = true
            bravoLabel.isHidden = false
            
        }
        
        buttonA.contentTintColor = .none
        buttonB.contentTintColor = .none
        buttonC.contentTintColor = .none
        buttonD.contentTintColor = .none
        
        progress.stringValue = "\(current) / 20"
        
        guard i <= 19 else { return }
        textField.title = english[sequence[i]]

        let table = UserDefaults.standard.object(forKey: userDefualtsCatagory)

        var a = DB.share.fetchThreeData(table: table as! String)
        a.append(chinese[sequence[i]])

        a = shuffleArray(arr: a)
        a = shuffleArray(arr: a)
        buttonA.title = a[0]
        buttonB.title = a[1]
        buttonC.title = a[2]
        buttonD.title = a[3]
        
        
    }

}


func shuffleArray(arr: [String]) -> [String] {
    var data: [String] = arr
    for i in 1..<arr.count {
        let index:Int = Int(arc4random()) % i
        if index != i {
            data.swapAt(i, index)
        }
    }
    return data
}

func shuffleArray(arr: [Int]) -> [Int] {
    var data: [Int] = arr
    for i in 1..<arr.count {
        let index:Int = Int(arc4random()) % i
        if index != i {
            data.swapAt(i, index)
        }
    }
    return data
}
