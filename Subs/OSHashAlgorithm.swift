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
    
    func hashForPath (_ path: String) -> VideoHash {
        var fileHash = VideoHash(fileHash: "", fileSize: 0)
        let fileHandler = FileHandle(forReadingAtPath: path)!
        
        let fileDataBegin: Data = fileHandler.readData(ofLength: chunkSize)
        fileHandler.seekToEndOfFile()
        
        let fileSize: UInt64 = fileHandler.offsetInFile
        if (UInt64(chunkSize) > fileSize) {
            return fileHash
        }
        
        fileHandler.seek(toFileOffset: max(0, fileSize - UInt64(chunkSize)))
        let fileDataEnd: Data = fileHandler.readData(ofLength: chunkSize)
        
        var hash: UInt64 = fileSize
        
        var data_bytes = UnsafeBufferPointer<UInt64>(
            start: (fileDataBegin as NSData).bytes.bindMemory(to: UInt64.self, capacity: fileDataBegin.count),
            count: fileDataBegin.count/MemoryLayout<UInt64>.size
        )
        hash = data_bytes.reduce(hash,&+)
        
        data_bytes = UnsafeBufferPointer<UInt64>(
            start: (fileDataEnd as NSData).bytes.bindMemory(to: UInt64.self, capacity: fileDataEnd.count),
            count: fileDataEnd.count/MemoryLayout<UInt64>.size
        )
        hash = data_bytes.reduce(hash,&+)
        
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
