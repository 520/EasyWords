import Cocoa

extension NSUserInterfaceItemIdentifier {
    static let collectionViewItem = NSUserInterfaceItemIdentifier("CollectionViewItem")
}

class CatagoryViewController: NSViewController {

    @IBOutlet weak var collectionView: NSCollectionView!
    var content = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        collectionView.collectionViewLayout = NSCollectionViewFlowLayout()
        collectionView.register(CatagoryCollectionItem.self, forItemWithIdentifier: .collectionViewItem)
        collectionView.dataSource = self
        collectionView.delegate = self
        updateData()
    }
    
    func updateData() {
        
        let c = UserDefaults.standard.object(forKey: userDefualtsCatagory) as! String
        
        var item1: [String: Any] = ["title" : "TOEFL", "button" : "Change", "tag" : 0]
        var item2: [String: Any] = ["title" : "GRE", "button" : "Change", "tag" : 1]
        
        switch c {
        case toefl:
            item1["button"] = "Using"
            item2["button"] = "Change"
        case gre:
            item1["button"] = "Change"
            item2["button"] = "Using"
        default:
            break
        }
        
        content.removeAll()
        content.append(item1)
        content.append(item2)
        
        self.collectionView.reloadData()
        
    }
    
    
}

extension CatagoryViewController: NSCollectionViewDelegate, NSCollectionViewDataSource {
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return content.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: .collectionViewItem, for: indexPath) as! CatagoryCollectionItem
        let itemIndex = (indexPath as NSIndexPath).item
        item.representedObject = content[itemIndex]
        item.success = { index in
            switch index {
            case 0:
                item.button.stringValue = "Using"
                if !DB.share.isEmpty(table: toefl) {
                    UserDefaults.standard.set(toefl, forKey: userDefualtsCatagory)
                    self.updateData()
                }
            case 1:
                 item.button.stringValue = "Using"
                if !DB.share.isEmpty(table: gre) {
                    UserDefaults.standard.set(gre, forKey: userDefualtsCatagory)
                    self.updateData()
                }
            default:
                break
            }
            
        }
        return item
    }
    
    
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {

    }
    
    
}

extension CatagoryViewController: NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSSize(width: 111, height: 111)
    }
}
