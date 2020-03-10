//
//  WindowMovable.swift
//  reciteVocabularyApp
//
//  Created by Richard Chui on 2020/2/22.
//  Copyright © 2020 Richard Technology (Shezhen)  Co., Ltd. All rights reserved.
//

import Cocoa

class WindowMovable: NSWindow {
    override  var canBecomeKey: Bool {
        return true
    }
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        self.isMovableByWindowBackground = true
    }
}
