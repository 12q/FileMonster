//
//  OperationsContainer.swift
//  FileMonster
//
//  Created by Slava Plis on 8/17/18.
//  Copyright © 2018 Slava Plis. All rights reserved.
//

import Foundation

// MARK: - Operation Stack - Protocol

protocol OperationStackDelegate: class {
    func didUpdate()
}

class OperationQueueFactory {
    static func `default`() -> OperationQueue {
        let queue = OperationQueue()
        queue.name = "com.mobndev.filemonster.queue"
        queue.maxConcurrentOperationCount = 5
        print("get com.mobndev.filemonster.queue")
        return queue
    }
}

// MARK: - Operation Stack - Init

class OperationStack {
    
    /// Wraper around the native OperationQueue
    ///`default` implementation for a stack that keeps operation queue
    /// with 5 parallel operations by default
    private var stack: OperationQueue = OperationQueueFactory.default()
    public weak var delegate: OperationStackDelegate?
    private var kvo: NSKeyValueObservation?
    
    init() {
        kvo = stack.observe(\.operations) { [unowned self] (stack, change) in
            DispatchQueue.main.async {
                self.didUpdate()
            }
        }
    }
}

//enum Result<T, E:Error> {
//    case success(T)
//    case failure(E)
//}

// MARK: - OperationStack - Interface

extension OperationStack {
    func add(operation: FileOperation) {
        stack.addOperation(operation)
    }
    
    func drop(oparation: FileOperation) {
        oparation.cancel()
    }
    
    public func currentCount() -> Int {
        return stack.operations.count
    }
    
    public func currentOperations() -> [FileOperation]? {
        if let fileOperations = stack.operations as? [FileOperation] {
            return fileOperations
        }
        return []
    }
}

// MARK: - OperationStack - Delegate

extension OperationStack {
    func didUpdate() {
        delegate?.didUpdate()
    }
}
