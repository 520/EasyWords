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
