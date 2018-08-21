//
//  ViewController.swift
//  FileMonster
//
//  Created by Slava Plis on 7/27/18.
//  Copyright © 2018 Slava Plis. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var open: NSButton!
    
    var urls: [URL] = []
    let loader = FileLoader()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func selectFolder(_ sender: Any) {
        let dialog = NSOpenPanel()
        dialog.title = "Select"
        dialog.allowsMultipleSelection = true
        dialog.canChooseDirectories = true
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            if let rootPath = dialog.url {
               loader.load(path: rootPath)
            }
        } else {
            return
        }
    }
}

//extension ViewController: NSTableViewDataSource {
//    func numberOfRows(in tableView: NSTableView) -> Int {
//        return 0
//    }
//}

//extension ViewController: NSTableViewDelegate {
//    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
////        let item = filesList[row]
//
//        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "Cell"), owner: nil) as? NSTableCellView {
////            cell.textField?.stringValue = item.exten
//            return cell
//        }
//        return nil
//    }
//}

//// MARK: - Data Structure
//
//enum ManagableType {
//    case file
//    case dir
//}
//
//protocol Managable {
//    var path: URL { get }
//    var type: ManagableType { get }
//}

//struct File: Managable {
//    internal var type: ManagableType
//    internal var path: URL
//    let name: String
//    let ext: String
//
//    init(at path: URL) {
//        self.name = path.lastPathComponent
//        self.ext = path.pathExtension
//        self.type = .file
//        self.path = path
//    }
//}
//
//struct Dir: Managable {
//    var path: URL
//    var type: ManagableType
//    var name: String {
//        return path.lastPathComponent + "[]"
//    }
//
//    init(at path: URL) {
//        self.path = path
//        self.type = .dir
//    }
//}
//
//public struct RefTree {
//    private var content: [Managable] = []
//
//    init(content: [Managable]) {
//        self.content = content
//    }
//
//    mutating func insert(_ element: Managable) {
//        content.append(element)
//        print(element)
//    }
//}

