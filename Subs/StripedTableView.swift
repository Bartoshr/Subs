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
    }
    
    override func highlightSelection(inClipRect clipRect: NSRect) {
        let evenColor = NSColor.red
        let oddColor = NSColor.blue
        
        let rowHeight = self.rowHeight + self.intercellSpacing.height
        let visibleRect = self.visibleRect
        var highlightRect = NSRect()
        
        Swift.print("Hello world")
        
        highlightRect.origin = NSMakePoint(NSMidX(visibleRect),(NSMinY(clipRect)/rowHeight)*rowHeight)
        highlightRect.size = NSMakeSize(NSWidth(visibleRect), rowHeight - self.intercellSpacing.height)
        
        while(NSMinY(highlightRect) < NSMaxX(clipRect)) {
            let clippedHighlightRect = NSIntersectionRect(highlightRect, clipRect)
            let row = (Int) ((NSMinY(highlightRect)+rowHeight/2.0)/rowHeight)
            
            let rowColor = (0 == row % 2) ? evenColor : oddColor
            rowColor.set()

            NSRectFill(clippedHighlightRect)
            highlightRect.origin.y += rowHeight
            
        }
        
        super.highlightSelection(inClipRect: clipRect)
    }

    
    override func drawRow(_ row: Int, clipRect: NSRect) {
        Swift.print("Draw row")
        super.drawRow(row, clipRect: clipRect)
    }
    
    override func drawBackground(inClipRect clipRect: NSRect) {
        super.drawBackground(inClipRect: clipRect)
        
        let evenColor = NSColor(calibratedRed: 0.25, green: 0.25, blue: 0.25, alpha: 1.00)
        let oddColor = NSColor(calibratedRed: 0.20, green: 0.20, blue: 0.20, alpha: 1.00)
        
        let rowHeight = self.rowHeight + self.intercellSpacing.height
        let visibleRect = self.visibleRect
        var highlightRect = NSRect()
        
        
        highlightRect.origin = NSMakePoint(0,(NSMinY(clipRect)/rowHeight)*rowHeight)
        highlightRect.size = NSMakeSize(NSWidth(visibleRect), rowHeight)
        
        while(NSMinY(highlightRect) <= NSMaxX(clipRect)) {
            let clippedHighlightRect = NSIntersectionRect(highlightRect, clipRect)
            let row = (Int) ((NSMinY(highlightRect)+rowHeight/2.0)/rowHeight)
            
            let rowColor = (0 == row % 2) ? evenColor : oddColor
            rowColor.set()
            
            NSRectFill(clippedHighlightRect)
            highlightRect.origin.y += rowHeight
        }
    }
    
    override func drawGrid(inClipRect clipRect: NSRect) {
        Swift.print("Draw Grid")
        super.drawGrid(inClipRect: clipRect)
    }
    
    
}
