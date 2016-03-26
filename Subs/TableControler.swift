//
//  TableControler.swift
//  Subs
//
//  Created by Bartosh on 06.03.2016.
//  Copyright © 2016 Bartosh. All rights reserved.
//

import Cocoa
import Alamofire
import AlamofireXMLRPC
import PathKit

class TableControler: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    @IBOutlet weak var tableView: NSTableView!
    
    var subtitles : [Subtitle] = []
    
    var rowSelectedMethod : ((Subtitle)->Void)?
    
    func numberOfRowsInTableView(aTableView: NSTableView) -> Int {
        return subtitles.count
    }
    
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let cellView: NSTableCellView = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! NSTableCellView
        
        if tableColumn!.identifier == "Subtitle" {
            cellView.textField!.stringValue = subtitles[row].subFileName
            return cellView
        }
        
        return cellView
    }
    
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        
        let myTableViewFromNotification = notification.object as! NSTableView
    
        if myTableViewFromNotification.numberOfSelectedRows != 0 {
            let indexes = myTableViewFromNotification.selectedRowIndexes
            let index = indexes.firstIndex
            
            rowSelectedMethod!(subtitles[index])
            
            NSApplication.sharedApplication().keyWindow?.orderOut(self)
            NSApplication.sharedApplication().hide(self)
        }
        
    }
}
