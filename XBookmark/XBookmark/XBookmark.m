//
//  XBookmark.m
//  XBookmark
//
//  Created by everettjf on 9/26/15.
//  Copyright © 2015 everettjf. All rights reserved.
//

#import "XBookmark.h"
#import "XBookmarkModel.h"

@interface XBookmark()

@property (nonatomic, strong, readwrite) NSBundle *bundle;
@property (nonatomic,strong) NSString *url;
@end

@implementation XBookmark

+ (instancetype)sharedPlugin
{
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        self.bundle = plugin;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didApplicationFinishLaunchingNotification:)
                                                     name:NSApplicationDidFinishLaunchingNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationLog:) name:nil object:nil];
    }
    return self;
}
- (void)notificationLog:(NSNotification *)notify
{
    if ([notify.name isEqualToString:@"transition from one file to another"]) {
        NSURL *originURL = [[notify.object valueForKey:@"next"] valueForKey:@"documentURL"];
        
        if (originURL != nil && [originURL absoluteString].length >= 7 ) {
            self.url = [originURL.absoluteString substringFromIndex:7];
        }
    }
}

- (void)didApplicationFinishLaunchingNotification:(NSNotification*)noti
{
    //removeObserver
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];
    
    // Create menu items, initialize UI, etc.
    // Sample Menu Item:
    
	unichar c = NSF3FunctionKey;
	NSString *f3 = [NSString stringWithCharacters:&c length:1];
    NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
    if (menuItem) {
        [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
        NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"Toggle Bookmark" action:@selector(toggleBookmark) keyEquivalent:f3];
        [actionMenuItem setKeyEquivalentModifierMask:0];
        [actionMenuItem setTarget:self];
        [[menuItem submenu] addItem:actionMenuItem];
    }
}

- (void)toggleBookmark
{
    NSLog(@"action url = %@",self.url);
    
    IDESourceCodeEditor* editor = [XBookmarkModel currentEditor];
    NSTextView* textView = editor.textView;
    if (nil == textView)
        return;
    
    NSRange range = [textView.selectedRanges[0] rangeValue];
    NSLog(@"range = %ld,%ld",range.location,range.length);
    
    NSUInteger lineNumber = [[[textView string]substringToIndex:range.location]componentsSeparatedByString:@"\n"].count;
    NSLog(@"current line = %ld",lineNumber);
        
        
//        NSRange lineRange = [[textView string]lineRangeForRange:range];
//        NSLog(@"line range = %ld,%ld",lineRange.location,lineRange.length);
    
    IDEWorkspaceDocument *document = [XBookmarkModel currentWorkspaceDocument];
    if(nil == document)
        return;
    DVTFilePath *filePath = document.workspace.representingFilePath;
    NSLog(@"file path = %@",filePath.fileURL);
    
    
    
//    [[NSWorkspace sharedWorkspace] selectFile:self.url inFileViewerRootedAtPath:@""];
//    NSAlert *alert = [[NSAlert alloc] init];
//    [alert setMessageText:@"Hello, World"];
//    [alert runModal];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
