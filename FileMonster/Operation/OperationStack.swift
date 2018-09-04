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
    func didUpdate(operations: [FileOperation])
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

// MARK: - OperationStack - Interface

extension OperationStack {
    func add(operation: FileOperation) {
        stack.addOperation(operation)
    }
}

// MARK: - OperationStack - Delegate

extension OperationStack {
    func didUpdate() {
        guard let operations = stack.operations as? [FileOperation] else { return }
        delegate?.didUpdate(operations: operations)
    }
}
