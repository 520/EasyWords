//
//  Alert.swift
//  reciteVocabularyApp
//
//  Created by Richard Chui on 2020/2/23.
//  Copyright © 2020 Richard Technology (Shezhen)  Co., Ltd. All rights reserved.
//

import Cocoa

struct Alert {
    init(window: NSWindow) {
        let alert = NSAlert()
        
        //增加一个按钮
        alert.addButton(withTitle: "Ok")
        //提示的标题
        alert.messageText = "Alert"
        //提示的详细内容
        alert.informativeText = "password length must be more than 6 "
        //设置告警风格
        alert.alertStyle = .informational
        alert.beginSheetModal(for: window, completionHandler: { returnCode in
            //当有多个按钮是 可以通过returnCode区分判断

        })
    }
}
