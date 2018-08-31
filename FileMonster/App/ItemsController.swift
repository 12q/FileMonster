//
//  ItemsController.swift
//  FileMonster
//
//  Created by Slava Plis on 8/16/18.
//  Copyright © 2018 Slava Plis. All rights reserved.
//

import Cocoa

class ItemsController: NSViewController {
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var selectButton: NSButton!
    @IBOutlet weak var moarButton: NSButton!
    @IBOutlet weak var duplicationButton: NSButton!
    
    var content: [File] = []

    /// Injected Services
    public var operationStack: OperationStack?
    public var fileLoader: Loader?
    public var dataStore: DataStore? {
        didSet {
            dataStore?.delegate = self
        }
    }
    
    /// User Actions
    @IBAction func selectFolder(_ sender: Any) {
        showSelectFolderDialog(option: .none)
    }
    
    @IBAction func addOneMorePath(_ sender: Any) {
        showSelectFolderDialog(option: .adding)
    }
    
    @IBAction func duplicatinSearch(_ sender: Any) {
        let duplication = SearchingDuplicatesOperation(with: content)
        operationStack?.add(operation: duplication)
    }
}

// MARK: - Selection Options for the New Paths

enum SelectOption {
    case none, renew, adding
}

// MARK: - File Open Panel

extension ItemsController {
    func showSelectFolderDialog(option: SelectOption) {
        let dialog = NSOpenPanel()
        dialog.message = "Please, select the Folder which shoud be processed by matched operations above."
        dialog.allowsMultipleSelection = true
        dialog.canChooseDirectories = true
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            if let selectedPath = dialog.url {
                guard let loader = fileLoader else { return }
                loader.load(path: selectedPath, option: option)
            }
        }
    }
}

// MARK: -  Data Store Delegate

extension ItemsController: DataStoreDelegate {
    func didUpdate(content: [File]) {
        self.content = content
        tableView.reloadData()
    }
}

// MARK: -  Table View Delegate

extension ItemsController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return content.count
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        let file = content[row]
        
        if tableColumn?.identifier.rawValue == "names" {
            return file.name
        }
        
        if tableColumn?.identifier.rawValue == "props" {
            return file.path
        }
        return "Check identifier for Cell ;P"
    }
}
