//
//  OperationsController.swift
//  FileMonster
//
//  Created by Slava Plis on 8/16/18.
//  Copyright © 2018 Slava Plis. All rights reserved.
//

import Cocoa

class OperationsController: NSViewController {
    @IBOutlet weak var tableView: NSTableView!
    
    private let operationStack = OperationStack.shared
    private var content: [FileOperation] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        operationStack.delegate = self
    }
}

// MARK: - TableView - DataSource

extension OperationsController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return operationStack.currentCount() 
    }
}

// MARK: - TableView - Delegate

extension OperationsController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
       
        let operation = content[row]
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "OperationCell"), owner: self) as? OperationCellView {
            cell.textField?.stringValue = operation.type.name()
            cell.operation = operation
            return cell
        }
        return nil
    }
}

// MARK: - OperationStack - Delegate

extension OperationsController: OperationStackDelegate {
    func didUpdate() {
        guard let operations = operationStack.currentOperations() else { return }
        content = operations
        tableView.reloadData()
    }
}


