//  OSHash.swift
//  Originally implemented from Objective-C version for Swift by omerucel 18/04/2015
//  http://trac.opensubtitles.org/projects/opensubtitles/wiki/HashSourceCodes#Objective-C
//  Updated for Swift 2 by eduo on  15/06/15.
//  Copyright © 2015 Eduardo Gutierrez. All rights reserved.
//

import Foundation

class OSHashAlgorithm: NSObject {
    let chunkSize: Int = 65536;
    
    struct VideoHash {
        var fileHash: String
        var fileSize: UInt64
    }
    
    func hashForPath (path: String) -> VideoHash {
        var fileHash = VideoHash(fileHash: "", fileSize: 0)
        let fileHandler = NSFileHandle(forReadingAtPath: path)!
        
        let fileDataBegin: NSData = fileHandler.readDataOfLength(chunkSize)
        fileHandler.seekToEndOfFile()
        
        let fileSize: UInt64 = fileHandler.offsetInFile
        if (UInt64(chunkSize) > fileSize) {
            return fileHash
        }
        
        fileHandler.seekToFileOffset(max(0, fileSize - UInt64(chunkSize)))
        let fileDataEnd: NSData = fileHandler.readDataOfLength(chunkSize)
        
        var hash: UInt64 = fileSize
        
        var data_bytes = UnsafeBufferPointer<UInt64>(
            start: UnsafePointer(fileDataBegin.bytes),
            count: fileDataBegin.length/sizeof(UInt64)
        )
        hash = data_bytes.reduce(hash,combine: &+)
        
        data_bytes = UnsafeBufferPointer<UInt64>(
            start: UnsafePointer(fileDataEnd.bytes),
            count: fileDataEnd.length/sizeof(UInt64)
        )
        hash = data_bytes.reduce(hash,combine: &+)
        
        fileHash.fileHash = String(format:"%qx", arguments: [hash])
        fileHash.fileSize = fileSize
        
        fileHandler.closeFile()
        return fileHash
    }
}

///var osha = OSHashAlgorithm()
///var result = osha.hashForPath(fileName)
///println(result.fileHash)
///println(result.fileSize)