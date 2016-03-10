//
//  Subtitle.swift
//  Subs
//
//  Created by Bartosh on 06.03.2016.
//  Copyright © 2016 Bartosh. All rights reserved.
//

import Foundation

class Subtitle {
    
    var fileName : String? = nil
    
    let subFileName : String
    let subDownloadLink: String
    let idSubtitleFile : String
    
    init(subFileName: String, subDownloadLink: String, idSubtitleFile: String) {
        self.subDownloadLink = subDownloadLink
        self.subFileName = subFileName
        self.idSubtitleFile = idSubtitleFile
    }
    
}