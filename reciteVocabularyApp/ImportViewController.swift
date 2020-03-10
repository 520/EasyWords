//
//  ImportViewController.swift
//  reciteVocabularyApp
//
//  Created by Richard Chui on 2020/2/24.
//  Copyright © 2020 Richard Technology (Shezhen)  Co., Ltd. All rights reserved.
//

import Cocoa

protocol ImportDelegate {
    func performDragOperation(urlStr: String)
}

class ImportViewController: NSViewController, ImportDelegate {
    
    var urlStr: String?
    @IBOutlet var importView: ImportView!
    
    func performDragOperation(urlStr: String) {
        self.urlStr = urlStr
    }
    
    @IBAction func importAction(_ sender: Any) {
        print(self.urlStr)
        if let urlStr = self.urlStr {
            let url = NSURL(fileURLWithPath: urlStr)
            print(url)
            guard let string = try? NSString.init(contentsOf: url as URL, encoding: String.Encoding.utf8.rawValue)
                else {
                    return
            }
            print((string as String).removeEmptyLine)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Import Vocabulary Table"
        importView.delegate = self
    }
    
    

}

class ImportView: NSView {
    
    var delegate: ImportDelegate?
    
    @IBOutlet var textView: NSTextView!
    var filePath: String?
    let expectedExt = ["txt", "doc", "docx", "sh"]
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.gray.cgColor

        registerForDraggedTypes([NSPasteboard.PasteboardType.URL, NSPasteboard.PasteboardType.fileURL])
    }

    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        if checkExtension(sender) == true {
            self.layer?.backgroundColor = NSColor.blue.cgColor
            return .copy
        } else {
            
            return NSDragOperation()
        }
    }

    fileprivate func checkExtension(_ drag: NSDraggingInfo) -> Bool {
        guard let board = drag.draggingPasteboard().propertyList(forType: NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")) as? NSArray,
              let path = board[0] as? String
        else { return false }

        let suffix = URL(fileURLWithPath: path).pathExtension
        for ext in self.expectedExt {
            if ext.lowercased() == suffix {
                return true
            }
        }
        return false
    }

    override func draggingExited(_ sender: NSDraggingInfo?) {
        self.layer?.backgroundColor = .none
    }

    override func draggingEnded(_ sender: NSDraggingInfo) {
        self.layer?.backgroundColor = .none
    }

    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let pasteboard = sender.draggingPasteboard().propertyList(forType: NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")) as? NSArray,
              let path = pasteboard[0] as? String
        else { return false }

        //GET YOUR FILE PATH !!!
        self.filePath = path
        
        let url = NSURL(fileURLWithPath: filePath!)
        guard let string = try?  NSString.init(contentsOf: url as URL, encoding: String.Encoding.utf8.rawValue)
            else {
                return true
        }
        self.textView.string = string as String
        delegate?.performDragOperation(urlStr: path)
        return true
    }
}
