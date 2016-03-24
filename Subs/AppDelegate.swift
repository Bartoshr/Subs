//
//  AppDelegate.swift
//  Subs
//
//  Created by Bartosh on 05.03.2016.
//  Copyright © 2016 Bartosh. All rights reserved.
//

import Cocoa
import PathKit
import Alamofire

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var tableControler: TableControler!
    
    let userAgent =  "OSTestUserAgent";
    let host = "https://api.opensubtitles.org:443/xml-rpc"
    
    var openSubtitles : OpenSubtitles?
    var searchService: SearchService?
    
    
    var token : String? = nil
    var subtitles : [Subtitle] = []
    var saveDirectory: String?
    
    let emptySound = NSSound(named: "Hero")
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        openSubtitles = OpenSubtitles(host: host, userAgent: userAgent)
        openSubtitles!.logIn(logedIn);
        tableControler.rowSelectedMethod = download
        
        searchService = SearchService()
        searchService?.method = procesFiles
        NSApp.servicesProvider = searchService
        NSUpdateDynamicServices()
    }
    
    // Actions
    
    func search(path: String){
        openSubtitles!.searchSubtitles(self.token!,
            path: path,
            properties: nil,
            callback:searchComlpeted)
    }
    
    func download(subtitle: Subtitle){
        openSubtitles!.downloadSubtitles(token!,
            subtitle: subtitle,
            callback: downloadCompleted)
    }
    
    func procesFiles(filenames: [String]){
        
        if(token == nil) {
            usleep(2000);
//            let alarm = NSAlert()
//            alarm.messageText = "Experimental"
//            alarm.runModal()
        }
        
        for filename in filenames {
            let directory = Path(filename).parent()
            print(directory.description)
            search(filename)
            saveDirectory = directory.description+"/"
        }
    }
    
    // Callbacks
    
    func logedIn(token: String){
        self.token = token
        print(token)
    }
    
    func logedOut(status: String){
        print(status)
    }
    
    func searchComlpeted(data: [Subtitle])->Void {
        
        if data.count == 0 {
            emptySound?.play()
            return
        }
        
        window.makeKeyAndOrderFront(self)
        tableControler.subtitles = data
        tableControler.tableView.reloadData()
        
    }
    
    
    func downloadCompleted(data: [String], filename: String)->Void {
        
        let decodedData = NSData(base64EncodedString: data[0], options:NSDataBase64DecodingOptions(rawValue: 0))
        let decompressedData : NSData = try! decodedData!.gunzippedData()
        decompressedData.writeToFile(saveDirectory!+filename, atomically: true)
        
    }
    
    // Application Handlers

    func applicationWillTerminate(aNotification: NSNotification) {
        openSubtitles!.logOut(token!, callback: logedOut)
    }
    
    func application(sender: NSApplication, printFile filename: String) -> Bool {
        print("file \(filename)")
        return true
    }
    
    func application(sender: NSApplication, openFiles filenames: [String]) {
        procesFiles(filenames)
    }
    

}

