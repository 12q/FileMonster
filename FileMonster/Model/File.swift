//
//  File.swift
//  FileMonster
//
//  Created by Slava Plis on 8/20/18.
//  Copyright © 2018 Slava Plis. All rights reserved.
//

import Foundation

enum ManagableType {
    case file
    case dir
}

struct File {
    internal var type: ManagableType
    internal var path: URL
    let name: String
    let ext: String

    init(with path: URL) {
        self.name = path.lastPathComponent
        self.ext = path.pathExtension
        self.type = .file
        self.path = path
    }
}
