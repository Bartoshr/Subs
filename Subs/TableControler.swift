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
    
    @IBOutlet weak var tableView: StripedTableView!
    
    var subtitles : [Subtitle] = []
    
    var rowSelectedMethod : ((Subtitle)->Void)?
    
    func numberOfRows(in aTableView: NSTableView) -> Int {
        return subtitles.count
    }
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let cellView: NSTableCellView = tableView.make(withIdentifier: tableColumn!.identifier, owner: self) as! NSTableCellView
        
        if tableColumn!.identifier == "Subtitle" {
            cellView.textField!.stringValue = subtitles[row].subFileName
            return cellView
        }
        
        return cellView
    }
    
    func tableView(_ tableView: NSTableView, didAdd rowView: NSTableRowView, forRow row: Int) {
        
        
        let evenColor = NSColor(calibratedRed: 0.25, green: 0.25, blue: 0.25, alpha: 1.00)
        let oddColor = NSColor(calibratedRed: 0.20, green: 0.20, blue: 0.20, alpha: 1.00)
        
        let bgColor = (row % 2 == 0) ? evenColor : oddColor
        rowView.backgroundColor = bgColor
    }
    
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        
        let myTableViewFromNotification = notification.object as! NSTableView
    
        if myTableViewFromNotification.numberOfSelectedRows != 0 {
            let indexes = myTableViewFromNotification.selectedRowIndexes
            let index = indexes.first
            
            rowSelectedMethod!(subtitles[index!])
            
            NSApplication.shared().keyWindow?.orderOut(self)
            NSApplication.shared().hide(self)
        }
    }

}
