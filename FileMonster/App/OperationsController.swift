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
    
    public var operationStack: OperationStack? {
        didSet {
            operationStack?.delegate = self
        }
    }
    private var content: [FileOperation] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - OperationStack - Delegate

extension OperationsController: OperationStackDelegate {
    func didUpdate() {
        guard let operations = operationStack?.currentOperations() else { return }
        content = operations
    }
}

// MARK: - TableView - DataSource

extension OperationsController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return content.count
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


