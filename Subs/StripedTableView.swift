//
//  StripedTableView.swift
//  Subs
//
//  Created by Bartosh on 10.12.2016.
//  Copyright © 2016 Bartosh. All rights reserved.
//

import Foundation
import Cocoa
class StripedTableView: NSTableView  {
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = NSColor(calibratedRed: 0.25, green: 0.25, blue: 0.25, alpha: 0.0)
    }
    
    override func drawBackground(inClipRect clipRect: NSRect) {
        super.drawBackground(inClipRect: clipRect)
        
//        let oddColor = NSColor(calibratedRed: 0.25, green: 0.25, blue: 0.25, alpha: 0)
//        let evenColor = NSColor(calibratedRed: 0.20, green: 0.20, blue: 0.20, alpha: 0)
                let evenColor = NSColor(calibratedRed: 1, green: 1, blue: 1, alpha: 0.1)
                let oddColor = NSColor(calibratedRed: 1, green: 1, blue: 1, alpha: 0.005)
        
        let rowHeight = self.rowHeight + self.intercellSpacing.height
        let visibleRect = self.visibleRect
        
        var highlightRect = NSRect()
        highlightRect.origin = NSMakePoint(0,(NSMinY(clipRect)/rowHeight)*rowHeight)
        highlightRect.size = NSMakeSize(NSWidth(visibleRect), rowHeight)
        
        while(NSMinY(highlightRect) < NSMaxX(clipRect)) {
            let clippedHighlightRect = NSIntersectionRect(highlightRect, clipRect)
            var row = (Int) ((NSMinY(highlightRect)+rowHeight/2.0)/rowHeight)
            
            if (NSMinY(clippedHighlightRect) < 0) {
                row=row+1
            }
            
            let rowColor = (0 == row % 2) ? evenColor : oddColor
            rowColor.set()
            
            NSRectFill(clippedHighlightRect)
            highlightRect.origin.y += rowHeight
        }
        
    }

    
}
