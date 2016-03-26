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
    
    var openSubtitles : OpenSubtitles
    var searchService: SearchService
    
    var token : String? = nil
    var subtitles : [Subtitle] = []
    
    var saveDirectory: String?
    var filename: String?
    
    let emptySound = NSSound(named: "Hero")
    
    var searchOnStartup = false;
    var filenames: [String]? = nil;
    
    override init(){
        openSubtitles = OpenSubtitles(host: host, userAgent: userAgent)
        searchService = SearchService()
        super.init()
        openSubtitles.logIn(logedIn)
        searchService.method = serviceLaunched
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        tableControler.rowSelectedMethod = download
        NSApp.servicesProvider = searchService
        NSUpdateDynamicServices()
    }
    
    // Actions
    
    func search(paths: [String]){
        openSubtitles.searchSubtitles(self.token!,
            paths: paths,
            properties: nil,
            callback:searchComlpeted)
    }
    
    func download(subtitle: Subtitle){
        openSubtitles.downloadSubtitles(token!,
            subtitle: subtitle,
            callback: downloadCompleted)
    }
    
    
    func procesFiles(filenames: [String]){
        let directory = Path(filenames[0]).parent()
        filename = Path(filenames[0]).lastComponent
        
        saveDirectory = directory.description+"/"
        print(directory.description)
        search(filenames)
    }
    
    // Callbacks
    
    func serviceLaunched(filenames: [String]){
        if(token == nil) {
            self.filenames = filenames
            searchOnStartup = true
        } else {
            procesFiles(filenames)
        }
    }
    
    func logedIn(token: String){
        self.token = token
        print(token)
        
        if(searchOnStartup == true) {
            procesFiles(filenames!)
            searchOnStartup = false
        }
    }
    
    func logedOut(status: String){
        print(status)
    }
    
    func searchComlpeted(data: [Subtitle])->Void {
        if data.count == 0 {
            emptySound?.play()
            return
        }
        
        window.title = filename!
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
        openSubtitles.logOut(token!, callback: logedOut)
    }
    
    func application(sender: NSApplication, openFiles filenames: [String]) {
        procesFiles(filenames)
    }
    

}

