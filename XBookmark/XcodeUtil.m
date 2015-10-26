//
//  XcodeUtil.m
//  XBookmark
//
//  Created by everettjf on 9/29/15.
//  Copyright © 2015 everettjf. All rights reserved.
//

#import "XcodeUtil.h"
#import <objc/runtime.h>

@implementation XcodeUtil


+ (IDEWorkspaceTabController*)tabController
{
    NSWindowController* currentWindowController =
        [[NSApp keyWindow] windowController];
    if ([currentWindowController
            isKindOfClass:NSClassFromString(@"IDEWorkspaceWindowController")]) {
        IDEWorkspaceWindowController* workspaceController = (IDEWorkspaceWindowController*)currentWindowController;

        return workspaceController.activeWorkspaceTabController;
    }
    return nil;
}

+ (id)currentEditor
{
    NSWindowController* currentWindowController =
        [[NSApp mainWindow] windowController];
    if ([currentWindowController
            isKindOfClass:NSClassFromString(@"IDEWorkspaceWindowController")]) {
        IDEWorkspaceWindowController* workspaceController = (IDEWorkspaceWindowController*)currentWindowController;
        IDEEditorArea* editorArea = [workspaceController editorArea];
        IDEEditorContext* editorContext = [editorArea lastActiveEditorContext];
        return [editorContext editor];
    }
    return nil;
}

+ (IDEWorkspace*)currentIDEWorkspace {
    return (IDEWorkspace*) [[XcodeUtil currentIDEWorkspaceWindowController] valueForKey:@"_workspace"];
}

+ (IDEWorkspaceDocument*)currentWorkspaceDocument
{
    NSWindowController* currentWindowController =
        [[NSApp mainWindow] windowController];
    id document = [currentWindowController document];
    if (currentWindowController &&
        [document isKindOfClass:NSClassFromString(@"IDEWorkspaceDocument")]) {
        return (IDEWorkspaceDocument*)document;
    }
    return nil;
}

+ (IDESourceCodeDocument*)currentSourceCodeDocument
{

    IDESourceCodeEditor* editor = [self currentEditor];

    if ([editor isKindOfClass:NSClassFromString(@"IDESourceCodeEditor")]) {
        return editor.sourceCodeDocument;
    }

    if ([editor
            isKindOfClass:NSClassFromString(@"IDESourceCodeComparisonEditor")]) {
        if ([[(IDESourceCodeComparisonEditor*)editor primaryDocument]
                isKindOfClass:NSClassFromString(@"IDESourceCodeDocument")]) {
            return (id)[(IDESourceCodeComparisonEditor*)editor primaryDocument];
        }
    }

    return nil;
}

+(NSString *)currentWorkspaceFilePath{
    IDEWorkspaceDocument *document = [XcodeUtil currentWorkspaceDocument];
    if(nil == document)
        return nil;
    DVTFilePath *workspacefilePath = document.workspace.representingFilePath;
    return [workspacefilePath.fileURL absoluteString];
}

+ (void)highlightLine:(NSUInteger)lineNumber inTextView:(NSTextView*)textView
{
    --lineNumber;
    
    NSString* text = [textView string];

    NSRegularExpression* re =
        [NSRegularExpression regularExpressionWithPattern:@"\n"
                                                  options:0
                                                    error:nil];

    NSArray* result = [re matchesInString:text
                                  options:NSMatchingReportCompletion
                                    range:NSMakeRange(0, text.length)];

    if (result.count <= lineNumber) {
        return;
    }

    NSUInteger location = 0;
    NSTextCheckingResult* aim = result[lineNumber];
    location = aim.range.location;

    NSRange range = [text lineRangeForRange:NSMakeRange(location, 0)];

    [textView scrollRangeToVisible:range];

    [textView setSelectedRange:range];
}

//+ (BOOL)slowOpenSourceFile:(NSString*)sourceFilePath highlightLineNumber:(NSUInteger)lineNumber
//{
//
//    NSWindowController* currentWindowController =
//        [[NSApp mainWindow] windowController];
//
//    // NSLog(@"currentWindowController %@",[currentWindowController description]);
//
//    if ([currentWindowController
//            isKindOfClass:NSClassFromString(@"IDEWorkspaceWindowController")]) {
//
//        // NSLog(@"Open in current Xocde");
//        id<NSApplicationDelegate> appDelegate = (id<NSApplicationDelegate>)[NSApp delegate];
//        if ([appDelegate application:NSApp openFile:sourceFilePath]) {
//
//            IDESourceCodeEditor* editor = [XcodeUtil currentEditor];
//            if ([editor isKindOfClass:NSClassFromString(@"IDESourceCodeEditor")]) {
//                NSTextView* textView = editor.textView;
//                if (textView) {
//
//                    [self highlightLine:lineNumber inTextView:textView];
//
//                    return YES;
//                }
//            }
//        }
//    }
//
//    // open the file
//    BOOL result = [[NSWorkspace sharedWorkspace] openFile:sourceFilePath
//                                          withApplication:@"Xcode"];
//
//    // open the line
//    if (result) {
//
//        // pretty slow to open file with applescript
//
//        NSString* theSource = [NSString
//            stringWithFormat:
//                @"do shell script \"xed --line %ld \" & quoted form of \"%@\"",
//                lineNumber, sourceFilePath];
//        NSAppleScript* theScript = [[NSAppleScript alloc] initWithSource:theSource];
//        [theScript performSelectorInBackground:@selector(executeAndReturnError:)
//                                    withObject:nil];
//
//        return NO;
//    }
//
//    return result;
//}

+ (IDEWorkspaceWindowController*)currentIDEWorkspaceWindowController {
    NSWindowController *mainWindowController = [[NSApp mainWindow] windowController];
    return (IDEWorkspaceWindowController *)mainWindowController;
}

+ (void)jumpToFileURL:(NSURL *)fileURL {
    DVTDocumentLocation *documentLocation = [[DVTDocumentLocation alloc] initWithDocumentURL:fileURL timestamp:nil];
    IDEEditorOpenSpecifier *openSpecifier = [IDEEditorOpenSpecifier structureEditorOpenSpecifierForDocumentLocation:documentLocation inWorkspace:[XcodeUtil currentIDEWorkspace]
    error:nil];
    [[XcodeUtil currentIDEWorkspaceWindowController].editorArea.lastActiveEditorContext openEditorOpenSpecifier:openSpecifier];
}

+ (NSUInteger)locationRangeForTextView:(DVTSourceTextView*)textView forLine:(NSUInteger)lineNumber {
    DVTTextStorage *textStorage = (DVTTextStorage*)textView.textStorage;
    NSRange characterRange = [textStorage characterRangeForLineRange:NSMakeRange(lineNumber, 0)];
    return characterRange.location;
}

+(BOOL)openSourceFile:(NSString *)sourceFilePath highlightLineNumber:(NSUInteger)lineNumber{
    NSString *currentPath = [XcodeUtil currentSourceCodeDocument].fileURL.path;
    if(![sourceFilePath isEqualToString:currentPath]){
        [self jumpToFileURL:[NSURL fileURLWithPath:sourceFilePath]];
    }

    IDESourceCodeEditor *editor = [XcodeUtil currentEditor];
    if (editor) {
        DVTSourceTextView* textView = editor.textView;
        
        NSUInteger lineLocation = [XcodeUtil locationRangeForTextView:textView forLine:lineNumber-1];
        NSRange locationRange = NSMakeRange(lineLocation, 0);
        		
        [textView setSelectedRange:locationRange];
        [textView scrollRangeToVisible:locationRange];
        [textView showFindIndicatorForRange:locationRange];
    }
    return YES;
}


@end
