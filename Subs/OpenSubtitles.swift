//
//  OpenSubtitles.swift
//  Subs
//
//  Created by Bartosh on 05.03.2016.
//  Copyright © 2016 Bartosh. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireXMLRPC
import PathKit




class OpenSubtitles {
    
    var host: String
    var userAgent: String
    
    
    // ISO 639.2
    enum Language: String {
        case English = "eng"
        case Polish = "pol"
    }
    
    init(host: String, userAgent: String){
        self.host = host
        self.userAgent = userAgent
    }
    
    func getServerInfo(_ callback: @escaping (String)->Void){
        execMethod("ServerInfo", params: []) { response in
            if let data = response, let info = data[0]["website_url"].string {
                callback(info)
            }
        }
    }
    
    func logIn(_ callback: @escaping (String)->Void){
        execMethod("LogIn", params: ["","","pl",userAgent]) { response in
            if let data = response, let token = data[0]["token"].string {
                callback(token)
            }
        }
    }
    
    func logOut(_ token : String, callback: @escaping (String)->Void){
        execMethod("LogOut", params: [token]) { response in
            if let data = response, let status = data[0]["status"].string {
                callback(status)
            }
        }
    }
    
    
    func searchSubtitles(_ token : String, paths: [String], properties: [String:Any]?,  callback: @escaping ([Subtitle])->Void){
        
        let table = paths.map{ (path) -> [String:Any]? in
            let osha = OSHashAlgorithm()
            let hash = osha.hashForPath(path).fileHash
            
            guard let result = properties else  {
                return ["moviehash":hash,"sublanguageid":"eng"]
            }
            
            return ["moviehash":hash,"sublanguageid":"eng"] + result
        }
        
        let limit = ["limit":100] as [String:Any]
        execMethod("SearchSubtitles", params: [token, table, limit]) { response in
            if let data = response, let table = data[0]["data"].array {
                
                var result : [Subtitle] = []
                
                for item in table {
                    let subFileName = item["SubFileName"].string
                    let subDownloadLink = item["SubFileName"].string
                    let idSubtitleFile = item["IDSubtitleFile"].string
                    
                    let subtitle = Subtitle(subFileName: subFileName!,
                        subDownloadLink: subDownloadLink!,
                        idSubtitleFile: idSubtitleFile!)
                    
                    let filename = Path(paths[0])
                    
                    subtitle.fileName = filename.lastComponent;
                    result.append(subtitle)
                }
                
                callback(result)
            }
        }
    }
    
    func searchSubtitles(_ token : String, paths: [String], lang: Language = Language.English,  callback: @escaping ([Subtitle])->Void){
        let properties = ["sublanguageid":lang.rawValue]
        searchSubtitles(token, paths: paths, properties: properties, callback: callback)
    }
    
    func downloadSubtitles(_ token : String, subtitle: Subtitle,  callback: @escaping ([String],String)->Void){
        let ids: [Any] = [subtitle.idSubtitleFile]
        execMethod("DownloadSubtitles", params: [token, ids]) { response in
            if let data = response, let table = data[0]["data"].array {
                
                var result : [String] = []
                
                for item in table {
                    let data = item["data"].string
                    result.append(data!)
                }
                
                callback(result, subtitle.subFileName)
            }
        }
    }
    
    
    func execMethod(_ methodName: String, params: [Any], callback : @escaping (XMLRPCNode?)->Void){
        AlamofireXMLRPC.request(host, methodName: methodName, parameters: params).responseXMLRPC { (response: DataResponse<XMLRPCNode>) -> Void in
            guard response.result.isSuccess else {
                let alert = NSAlert()
                alert.messageText = "Failure for \(methodName) \n \(response.description)"
                alert.runModal()
                return
            }
            if let value = response.result.value {
                callback(value)
            }
        }
    }
    
}
