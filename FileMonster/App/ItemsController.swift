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
    
    @IBOutlet weak var operationBox: NSBox!
    @IBOutlet weak var duplicationButton: NSButton!
    @IBOutlet weak var calculateHashButton: NSButton!
    
    @IBOutlet weak var runButton: NSButton!
    
    fileprivate var content: [File] = [] {
        didSet {
            guard content.count > 0 else { return }
            duplicationButton.isEnabled = true
            calculateHashButton.isEnabled = true
        }
    }

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
        duplicationButton.isBordered =  !duplicationButton.isBordered

       
    }
    
    @IBAction func calculateHash(_ sender: Any) {
        calculateHashButton.isBordered = !calculateHashButton.isBordered
    }
    
    /// Create the matched operations
    /// and push them into the stack
    @IBAction func runSelectedOperations(_ sender: Any) {
        /*
         Trackig selected opereation by isBordered property of its button
         Sorry 'bout that:]
         */
        if duplicationButton.isBordered {
            let duplicationOperation = SearchingDuplicatesOperation(with: content)
            duplicationButton.isEnabled = false
            duplicationOperation.completionBlock = { [unowned self] in
                DispatchQueue.main.async {
                    self.duplicationButton.isEnabled = true
                }
            }
            operationStack?.add(operation: duplicationOperation)
        }
        
        if calculateHashButton.isBordered {
            // DO SOMETHING
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

        configure(cell: cell, row: row)
        return cell
    }
    
    @discardableResult
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
            print("Check ItemsController: func configure {...}")
        }
        
        return cell
    }
}

