//
//  StringExtension.swift
//  reciteVocabularyApp
//
//  Created by Richard Chui on 2020/2/24.
//  Copyright © 2020 Richard Technology (Shezhen)  Co., Ltd. All rights reserved.
//

import Foundation

extension StringProtocol {
    var lines: [SubSequence] { split { $0.isNewline } }
    var removeEmptyLine: String { lines.joined(separator: "\n")}
    var isAlphabet: Bool {
        let letterRegex:NSPredicate=NSPredicate(format:"SELF MATCHES %@","^.*[A-Za-z]+.*$")
            if letterRegex.evaluate(with: self) { return true } else { return false }
    }
    var isChinese: Bool {
        let value = self.prefix(1)
        if ("\u{4E00}" <= value  && value <= "\u{9FA5}") { return true } else { return false }
    }
}


