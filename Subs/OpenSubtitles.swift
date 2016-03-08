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


class OpenSubtitles {
    
    var host: String
    var userAgent: String
    
    init(host: String, userAgent: String){
        self.host = host
        self.userAgent = userAgent
    }
    
    
    
    func getServerInfo(callback: (String)->Void){
        execMethod("ServerInfo", params: []) { response in
            if let data = response, info = data[0]["website_url"].string {
                callback(info)
            }
        }
    }
    
    func logIn(callback: (String)->Void){
        execMethod("LogIn", params: ["","","pl",userAgent]) { response in
            if let data = response, token = data[0]["token"].string {
                callback(token)
            }
        }
    }
    
    func logOut(token : String, callback: (String)->Void){
        execMethod("LogOut", params: [token]) { response in
            if let data = response, status = data[0]["status"].string {
                callback(status)
            }
        }
    }
    
    
    func searchSubtitles(token : String, properties: XMLRPCStructure,  callback: ([Subtitle])->Void){
        let table = [properties] as XMLRPCArray
        let limit = ["limit":100] as XMLRPCStructure
        execMethod("SearchSubtitles", params: [token, table, limit]) { response in
            if let data = response, table = data[0]["data"].array {
                
                var result : [Subtitle] = []
                
                for item in table {
                    let subFileName = item["SubFileName"].string
                    let subDownloadLink = item["SubFileName"].string
                    let idSubtitleFile = item["IDSubtitleFile"].string
                    result.append(Subtitle(subFileName: subFileName!,
                        subDownloadLink: subDownloadLink!,
                        idSubtitleFile: idSubtitleFile!))
                }
                
                callback(result)
            }
        }
    }
    
    func downloadSubtitles(token : String, ids: XMLRPCArray,  callback: ([String])->Void){
        execMethod("DownloadSubtitles", params: [token, ids]) { response in
            if let data = response, table = data[0]["data"].array {
                
                var result : [String] = []
                
                for item in table {
                    let data = item["data"].string
                    result.append(data!)
                }
                
                callback(result)
            }
        }
    }
    
    
    func execMethod(methodName: String, params: [Any], callback : (XMLRPCNode?)->Void){
        AlamofireXMLRPC.request(host, methodName: methodName, parameters: params).responseXMLRPC { (response:Response<XMLRPCNode, NSError>) -> Void in
            guard response.result.isSuccess else {
                print("Failure for \(methodName)")
                return
            }
            if let value = response.result.value {
                callback(value)
            }
        }
    }
    
    
    
}