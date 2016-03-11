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
    
    let userAgent =  "OSTestUserAgent";
    let host = "https://api.opensubtitles.org:443/xml-rpc"
    
    var token : String = ""
    var subtitles : [Subtitle] = []
    var openSubtitles : OpenSubtitles
    
    var directory: String? = nil

    required init?(coder: NSCoder) {
        openSubtitles = OpenSubtitles(host: host, userAgent: userAgent)
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        openSubtitles.logIn(logedIn);
    }
    
    // Actions
    
    func search(path: String){
        openSubtitles.searchSubtitles(self.token,
            path: path,
            properties: nil,
            callback:searchComlpeted)
    }
    
    func download(id: String){
        let props = [id] as XMLRPCArray
        openSubtitles.downloadSubtitles(token,
            ids: props,
            callback: downloadCompleted)
    }
    
    
    // Controler Life Cycle
    
    func logedIn(token: String){
        self.token = token
        print(token)
    }
    

    func searchComlpeted(data: [Subtitle])->Void {
        self.subtitles = data
        self.tableView.reloadData()
    }
    
    
    func downloadCompleted(data: [String])->Void {
        let decodedData = NSData(base64EncodedString: data[0], options:NSDataBase64DecodingOptions(rawValue: 0))
        let decompressedData : NSData = try! decodedData!.gunzippedData()
        decompressedData.writeToFile(directory!+"paczka.srt", atomically: true)
    }
    
    func numberOfRowsInTableView(aTableView: NSTableView) -> Int {
        return subtitles.count
    }
    
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let cellView: NSTableCellView = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! NSTableCellView
        
        if tableColumn!.identifier == "SubsColumn" {
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
            download(subtitles[index].idSubtitleFile)
            NSApplication.sharedApplication().keyWindow?.orderOut(self)
            NSApplication.sharedApplication().hide(self)
        }
        
    }
}
