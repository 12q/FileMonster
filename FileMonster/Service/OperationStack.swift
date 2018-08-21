//
//  OperationsContainer.swift
//  FileMonster
//
//  Created by Slava Plis on 8/17/18.
//  Copyright © 2018 Slava Plis. All rights reserved.
//

import Foundation

protocol OperationStackDelegate {
    func didUpdate()
}

class OperationStack {
    var stack: OperationQueue {
        let queue = OperationQueue()
        queue.name = "Operation_Stack_Queue"
        queue.maxConcurrentOperationCount = 4
        return queue
    }
    
    /// Adding operation into Queue and Launch
    func add(op: FileOperation) {
        stack.addOperation(op)
        op.start()
    }
}

class FileOperation: Operation {
    var progress: Progress?
    
    init(with type: String) {
        
    }
}



