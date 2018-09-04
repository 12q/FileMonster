//
//  FileOperation.swift
//  FileMonster
//
//  Created by Slava Plis on 8/30/18.
//  Copyright © 2018 Slava Plis. All rights reserved.
//

import Foundation

protocol OperationProgressDelegate: AnyObject {
    func didUpdateProgress(fractionCompleted: Double)
}

class FileOperation: Operation {
    public weak var delegate: OperationProgressDelegate?
    public let type: OperationType
    internal var content: [File]
    
    init(with content: [File], type: OperationType) {
        self.type = type
        self.content = content
    }
}
