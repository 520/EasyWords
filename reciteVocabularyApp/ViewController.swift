import Cocoa
import FMDB

class ViewController: NSViewController {
    
    var speak: Speak?
    
    @IBOutlet weak var tableView: NSTableView!
    var data: [(chinese: String, english: String)] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    func updateData() {

        guard let c = UserDefaults.standard.array(forKey: userDefaultsChinese), let e = UserDefaults.standard.array(forKey: userDefaultsEnglish) else { return }
        if c.count > 0 {
            var set = [(chinese: String, english: String)]()
            for i in 0..<c.count {
                set.append((chinese: c[i] as! String, english: e[i] as! String))
            }
            
            self.data = set
            
        }
 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateData()
        tableView.selectionHighlightStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.action = #selector(oneAction(_:))
        NotificationCenter.default.addObserver(self, selector: #selector(selectorQuiz), name: notificationQuiz, object: nil)
    }
    
    @objc func selectorQuiz(notification: Notification) {
        let status = notification.object as! enumQuiz
        if status == .on {
            transitionAnimation()
            tableView.isHidden = true
        } else {
            transitionAnimation()
            tableView.isHidden = false
        }
    }
    
    func transitionAnimation() {
        let transition = CATransition()
        transition.startProgress = 0
        transition.endProgress = 1
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        transition.duration = 0.2
        self.tableView!.layer?.add(transition, forKey: "transition")
    }
    
    @objc func oneAction(_ sender: NSTableView) {
        if sender.selectedRow == -1 { return }
        let voc = self.data[sender.selectedRow].english
        if speak != nil { speak?.stop() }
        speak = Speak()
        speak?.play(voc)
        
        for i in [0,1] {
        let view = sender.view(atColumn: i, row: tableView.selectedRow, makeIfNecessary: false)
        let subviews = view?.subviews
        let textField = subviews?[0] as! NSTextField
        textField.textColor = NSColor.white
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1, execute: {
            textField.textColor = NSColor.white.withAlphaComponent(0.6)
        })
        }
        
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.red.cgColor
    }
    
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

}

extension ViewController: NSTableViewDelegate, NSTableViewDataSource {
   
//    func tableViewSelectionDidChange(_ notification: Notification) {
//        let tableView = notification.object as! NSTableView
//        let view = tableView.view(atColumn: 0, row: tableView.selectedRow, makeIfNecessary: false)
//        let subviews = view?.subviews
//        let textField = subviews?[0] as! NSTextField
//        textField.font = NSFont.boldSystemFont(ofSize: 16)
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1, execute: {
//            textField.font = NSFont.systemFont(ofSize: 16, weight: .ultraLight)
//        })
//
//        let view1 = tableView.view(atColumn: 1, row: tableView.selectedRow, makeIfNecessary: false)
//        let subviews1 = view1?.subviews
//        let textField1 = subviews1?[0] as! NSTextField
//        textField1.font = NSFont.boldSystemFont(ofSize: 16)
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1, execute: {
//            textField1.font = NSFont.systemFont(ofSize: 16, weight: .ultraLight)
//        })
//
//    }
//
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let data = self.data[row]

        let key = (tableColumn?.identifier)!

        let view = tableView.makeView(withIdentifier: key, owner: self)

        let subviews = view?.subviews

        if (subviews?.count)!<=0 {
            return nil
        }

        if key.rawValue == "chinese" {
            let textField = subviews?[0] as! NSTextField
            textField.stringValue = data.chinese
        }

        if key.rawValue == "english" {
            let textField = subviews?[0] as! NSTextField
            textField.stringValue = data.english
        }

        return view
        
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 30
    }
}
