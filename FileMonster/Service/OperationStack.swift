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
    }
    
    func run() {
        
    }
}

class FileOperation: Operation {
//    var progress: Progress?
    var inputContent: [File]
    var result: [File] = []
    
    init(with content: [File]) {
        self.inputContent = content
    }
    
    override func main() {
        let manager = FileManager()
        for file in inputContent {
            let res = inputContent.filter {
               manager.contentsEqual(atPath: file.path.path, andPath: $0.path.path)
            }
            print("\(inputContent.index(of: file)!) from \(String(describing:inputContent.count))")
            
            if res.count > 1 { result.append(contentsOf: res) }
        }
        result.map { print($0.name)}
    }
    
}



