//
//  OperationsController.swift
//  FileMonster
//
//  Created by Slava Plis on 8/16/18.
//  Copyright © 2018 Slava Plis. All rights reserved.
//

import Cocoa

class OperationsController: NSViewController {

    @IBOutlet weak var selectButton: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    
    let loader = ContentLoader()
    var urls: [URL] = []

    @IBAction func selectFolder(_ sender: Any) {
        let dialog = NSOpenPanel()
        dialog.title = "Select Path"
        dialog.message = "Please, select the Folder which shoud be processed by matched operations above."
        dialog.allowsMultipleSelection = true
        dialog.canChooseDirectories = true
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            if let rootPath = dialog.url {
                urls = loader.load(rootPath)
                print(urls)
            }
        } else {
            return
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
enum OperationType {
    case FileterByName, FindDuplicates, SortByMake
    
    func name() -> String {
        switch self {
        case .FileterByName:
            return "Filter by Alhabetic"
        case .FindDuplicates:
            return "Searching for duplicates"
        case .SortByMake:
            return "Categorize images"
        default:
            return "No Option"
        }
    }
}

extension OperationType {
    static var allValues: [OperationType] {
        return [.FileterByName, .FindDuplicates, .SortByMake]
    }
}

extension OperationsController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return OperationType.allValues.count
    }
}

extension  OperationsController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "OperationCell"), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue =  OperationType.allValues[row].name()
            return cell
        }
        return nil
    }
}


