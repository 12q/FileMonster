//
//  RootWindowController.swift
//  FileMonster
//
//  Created by Slava Plis on 8/16/18.
//  Copyright © 2018 Slava Plis. All rights reserved.
//

import Cocoa

class RootWindowController: NSWindowController {
    
    convenience init() {
        self.init(windowNibName: NSNib.Name(rawValue: "RootWindowController"))
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        /// Services
        /// kinda DI
        let store = DataStore()
        let loader = FileLoader(dataStore: store)
        let stack = OperationStack()
        

        /// Base View Controller
        let spitController = NSSplitViewController()
        
        /// View Controller
        /// - shows current operations list
        /// * each operation shows its progress and could be canceled

        let currentOperationsViewController = OperationsController()
        currentOperationsViewController.operationStack = stack
        
        /// View Controller shows the content of the selected folder
        /// - selects the path to operate with
        /// - performs the oprations
        /// - displays the result of the performed opration
        
        let fileBrowserViewController = ItemsController()
        fileBrowserViewController.dataStore = store
        fileBrowserViewController.fileLoader = loader
        fileBrowserViewController.operationStack = stack

        spitController.addSplitViewItem(NSSplitViewItem(viewController: currentOperationsViewController))
        spitController.addSplitViewItem(NSSplitViewItem(viewController: fileBrowserViewController))
        
        // Setting Up the Root Controller
        window?.contentViewController = spitController
    }
    
}
