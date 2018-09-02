//
//  ItemsController.swift
//  FileMonster
//
//  Created by Slava Plis on 8/16/18.
//  Copyright © 2018 Slava Plis. All rights reserved.
//

import Cocoa

/// Cell Identifiers
fileprivate enum Identifiers {
    static let NameCell = "NameCellIdentifier"
    static let DateCell = "DateCellIdentifier"
    static let SizeCell = "SizeCellIdentifier"
}

class ItemsController: NSViewController {
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var selectButton: NSButton!
    @IBOutlet weak var moarButton: NSButton!
    @IBOutlet weak var duplicationButton: NSButton!
    
    fileprivate var content: [File] = []

    /// Injected Services
    public var operationStack: OperationStack?
    public var fileLoader: Loader?
    public var dataStore: DataStore? {
        didSet {
            dataStore?.delegate = self
        }
    }
    
    /// Formaters
    let sizeFormatter = ByteCountFormatter()
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateStyle = .full
//    dateFormatter.timeStyle = .none
    
    
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
        
        duplicationButton.isEnabled = false
        duplication.completionBlock = { [unowned self] in
            DispatchQueue.main.async {
                self.duplicationButton.isEnabled = true
            }
        }
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
}

extension ItemsController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {

        guard let identifier = tableColumn?.identifier else { return nil }
        guard let cell = tableView.makeView(withIdentifier: identifier, owner: nil) as? NSTableCellView else { return nil }

        let a = configure(cell: cell, row: row)
        
        return a
    }

    func configure(cell: NSTableCellView, row: Int) -> NSTableCellView {
        /* erm, strange compiler behavior
         see: line 37
         uncommnent and try to build
         */
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        let file = content[row]
        guard let identifier = cell.identifier?.rawValue else { return cell }
        
        switch identifier {
        case Identifiers.NameCell:
            cell.imageView?.image = file.icon ?? NSImage()
            cell.textField?.stringValue = file.name
        case Identifiers.DateCell:
            cell.textField?.stringValue = dateFormatter.string(from: file.date ?? Date())
        case Identifiers.SizeCell:
            cell.textField?.stringValue = sizeFormatter.string(fromByteCount: file.size ?? Int64(0))
        default:
            print("fdfd")
        }
        
        return cell
    }
}

//
//    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
//        let file = content[row]
//
//        if tableColumn?.identifier.rawValue == "icon" {
//            return file.icon ?? NSImage()
//        }
//
//        if tableColumn?.identifier.rawValue == "name" {
//            return file.name
//        }
//
//        if tableColumn?.identifier.rawValue == "date" {
//            return dateFormatter.string(from: file.date ?? Date())
//        }
//
//        if tableColumn?.identifier.rawValue == "size" {
//            return sizeFormatter.string(fromByteCount: file.size ?? Int64(0))
//        }
//
//        return "Check identifier for Cell ;P"
//    }

