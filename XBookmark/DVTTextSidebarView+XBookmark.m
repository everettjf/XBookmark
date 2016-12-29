//
//  DVTTextSidebarView+XBookmark.m
//  XBookmark
//
//  Created by everettjf on 10/31/15.
//  Copyright © 2015 everettjf. All rights reserved.
//

#import "DVTTextSidebarView+XBookmark.h"
#import "JRSwizzle.h"
#import "IDEKit.h"
#import "XBookmarkModel.h"

@implementation DVTTextSidebarView (XBookmark)

+(void)load{
    NSError *error = nil;
    // Xcode 7
    [DVTTextSidebarView jr_swizzleMethod:@selector(_drawLineNumbersInSidebarRect:foldedIndexes:count:linesToInvert:linesToReplace:getParaRectBlock:)
                              withMethod:@selector(xbookmark_xcode7_drawLineNumbersInSidebarRect:foldedIndexes:count:linesToInvert:linesToReplace:getParaRectBlock:)
                                   error:& error];
    
    // Xcode 8
    [DVTTextSidebarView jr_swizzleMethod:@selector(_drawLineNumbersInSidebarRect:foldedIndexes:count:linesToInvert:linesToHighlight:linesToReplace:textView:getParaRectBlock:)
                              withMethod:@selector(xbookmark_drawLineNumbersInSidebarRect:foldedIndexes:count:linesToInvert:linesToHighlight:linesToReplace:textView:getParaRectBlock:)
                                   error:& error];
    
}


// Xcode 7
- (void)xbookmark_xcode7_drawLineNumbersInSidebarRect:(CGRect)rect
                                 foldedIndexes:(NSUInteger *)indexes
                                         count:(NSUInteger)indexCount
                                 linesToInvert:(id)invert
                                linesToReplace:(id)replace
                              getParaRectBlock:(id)rectBlock{
    NSString *fileName = self.window.representedFilename;
    
    for(NSUInteger idx = 0; idx < indexCount; ++idx){
        NSUInteger line = indexes[idx];
        if([[XBookmarkModel sharedModel]hasBookmark:fileName lineNumber:line]){
            [self xbookmark_drawBookmarkAtLine:line];
        }
    }
    
    [self xbookmark_xcode7_drawLineNumbersInSidebarRect:rect foldedIndexes:indexes count:indexCount linesToInvert:invert linesToReplace:replace getParaRectBlock:rectBlock];
}

// Xcode 8
- (void)xbookmark_drawLineNumbersInSidebarRect:(CGRect)rect
                                 foldedIndexes:(NSUInteger *)indexes
                                         count:(NSUInteger)indexCount
                                 linesToInvert:(id)invert
                              linesToHighlight:(id)highlight
                                linesToReplace:(id)replace
                                      textView:(id)textView
                              getParaRectBlock:(GetParaBlock)rectBlock{
    NSString *fileName = self.window.representedFilename;
    
    for(NSUInteger idx = 0; idx < indexCount; ++idx){
        NSUInteger line = indexes[idx];
        if([[XBookmarkModel sharedModel]hasBookmark:fileName lineNumber:line]){
            [self xbookmark_drawBookmarkAtLine:line];
        }
    }
    
    [self xbookmark_drawLineNumbersInSidebarRect:rect foldedIndexes:indexes count:indexCount linesToInvert:invert linesToHighlight:highlight linesToReplace:replace textView:textView getParaRectBlock:rectBlock];
}

static inline NSPoint NSPointRelativeTo(NSPoint point,NSPoint origin){
    return NSMakePoint(origin.x + point.x, origin.y + point.y);
}
static inline NSPoint NSPointRelativeToXY(CGFloat x, CGFloat y,NSPoint origin){
    return NSPointRelativeTo(NSMakePoint(x, y),origin);
}

-(void)xbookmark_drawBookmarkAtLine:(NSUInteger)lineNumber{
    CGRect paragRect,lineRect;
    [self getParagraphRect:&paragRect firstLineRect:&lineRect forLineNumber:lineNumber];
    
    //// Color Declarations
    NSColor* color = [NSColor colorWithCalibratedRed: 0.948 green: 0.664 blue: 0.107 alpha: 1];
    
    //// Star Drawing
    NSBezierPath* starPath = NSBezierPath.bezierPath;
    [starPath moveToPoint: NSPointRelativeToXY(8.5, 0,lineRect.origin)];
    [starPath lineToPoint: NSPointRelativeToXY(11.02, 5.03,lineRect.origin)];
    [starPath lineToPoint: NSPointRelativeToXY(16.58, 5.87,lineRect.origin)];
    [starPath lineToPoint: NSPointRelativeToXY(12.58, 9.82,lineRect.origin)];
    [starPath lineToPoint: NSPointRelativeToXY(13.5, 15.38,lineRect.origin)];
    [starPath lineToPoint: NSPointRelativeToXY(8.5, 12.79,lineRect.origin)];
    [starPath lineToPoint: NSPointRelativeToXY(3.5, 15.38,lineRect.origin)];
    [starPath lineToPoint: NSPointRelativeToXY(4.42, 9.82,lineRect.origin)];
    [starPath lineToPoint: NSPointRelativeToXY(0.42, 5.87,lineRect.origin)];
    [starPath lineToPoint: NSPointRelativeToXY(5.98, 5.03,lineRect.origin)];
    [starPath closePath];
    [color setFill];
    [starPath fill];
}

@end
