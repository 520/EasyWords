//
//  SearchViewController.swift
//  reciteVocabularyApp
//
//  Created by Richard Chui on 2020/2/25.
//  Copyright © 2020 Richard Technology (Shezhen)  Co., Ltd. All rights reserved.
//

import Cocoa

class SearchViewController: NSViewController {

    var keyword: String = "" {
        didSet {
            self.data = DB.share.fetchLikeData(table: oxford, keyword: keyword)
        }
    }
    
    var data: [(chinese: String, english: String)] = [] {
        didSet {
            tableView.reloadData()
            //print(data)
        }
    }
    
    
    @IBOutlet weak var soundButton: NSButton!
    @IBOutlet weak var wordLabel: NSTextFieldCell!
    @IBOutlet var explainLabel: NSTextView!
    @IBOutlet weak var tableView: NSTableView!
    @IBAction func searchField(_ sender: NSSearchField) {
        keyword = sender.stringValue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func soundAction(_ sender: Any) {
        let speak = Speak()
        speak.play(wordLabel.title)
    }
    
}

extension SearchViewController: NSTableViewDelegate, NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let data = self.data[row]
        
        let identifier = tableColumn!.identifier
        
        let view = tableView.makeView(withIdentifier: identifier, owner: self)
        
        if (view?.subviews.count)! < 1 {
            return nil
        }
        let textField = view?.subviews[0] as! NSTextField
        
        if identifier.rawValue == "chinese" {
            let p = process(data.chinese)
            textField.stringValue = p
        }
        
        if identifier.rawValue == "english" {
            textField.stringValue = data.english
        }
        
        return view
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        wordLabel.stringValue = data[row].english
        explainLabel.string = process(data[row].chinese)
        
        soundButton.isHidden = false
        
        return true
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 30
    }
    
    func process(_ str: String) -> String {
        var arr = [Int]()
        str.enumerated().forEach {
            if $0.element == "/" {
                arr.append($0.offset)
            }
        }
        if arr.count != 0 {
            if arr[0] == 0 {
                let p = str.suffix(str.count - arr[1] - 1)
                return String(p)
            }
        }
        return str
    }
    
//    func indent(_ str: String) -> String {
//        var temp = ""
//        var beforeIsChinese = 0
//        var after
//        str.enumerated().forEach {
//            if ("\u{4E00}" <= $0.element  && $0.element <= "\u{9FA5}") && alphaBehind == true {
//                temp+="/n"
//                temp+="\($0.element)"
//                alphaBehind = false
//            }else if alphaBehind == false{
//                temp+="\($0.element)"
//            }
//        }
//        return temp
//    }
}
