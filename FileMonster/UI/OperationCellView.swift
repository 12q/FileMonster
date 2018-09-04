//
//  OperationCellView.swift
//  FileMonster
//
//  Created by Slava Plis on 8/30/18.
//  Copyright © 2018 Slava Plis. All rights reserved.
//

import Cocoa

class OperationCellView: NSTableCellView {
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    public var operation: FileOperation? {
        didSet {
            operation?.delegate = self
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        operation?.cancel()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension OperationCellView: OperationProgressDelegate {
    func didUpdateProgress(fractionCompleted: Double) {
        DispatchQueue.main.async { [unowned self] in
            self.progressIndicator.doubleValue = fractionCompleted
        }
    }
}
