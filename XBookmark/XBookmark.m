//
//  XBookmark.m
//  XBookmark
//
//  Created by everettjf on 9/26/15.
//  Copyright © 2015 everettjf. All rights reserved.
//

#import "XBookmark.h"
#import "XcodeUtil.h"
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
//    NSLog(@"notify name = %@",notify.name);
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
    
	unichar cf3 = NSF3FunctionKey;
	NSString *f3 = [NSString stringWithCharacters:&cf3 length:1];
    
    NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
    if (menuItem) {
        [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
        
        {
            NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"Toggle Bookmark" action:@selector(toggleBookmark) keyEquivalent:f3];
            [actionMenuItem setKeyEquivalentModifierMask:0];
            [actionMenuItem setTarget:self];
            [[menuItem submenu] addItem:actionMenuItem];
        }
        {
            NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"Next Bookmark" action:@selector(nextBookmark) keyEquivalent:f3];
            [actionMenuItem setKeyEquivalentModifierMask:NSControlKeyMask];
            [actionMenuItem setTarget:self];
            [[menuItem submenu] addItem:actionMenuItem];
        }
        {
            NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"Previous Bookmark" action:@selector(previousBookmark) keyEquivalent:f3];
            [actionMenuItem setKeyEquivalentModifierMask:NSShiftKeyMask | NSControlKeyMask];
            [actionMenuItem setTarget:self];
            [[menuItem submenu] addItem:actionMenuItem];
        }
        {
            NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"Show Bookmarks" action:@selector(showBookmarks) keyEquivalent:f3];
            [actionMenuItem setKeyEquivalentModifierMask:NSShiftKeyMask];
            [actionMenuItem setTarget:self];
            [[menuItem submenu] addItem:actionMenuItem];
        }
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)toggleBookmark
{
//    NSString *workspaceFilePath = [XcodeUtil currentWorkspaceFilePath];
    
    IDESourceCodeEditor* editor = [XcodeUtil currentEditor];
    NSTextView* textView = editor.textView;
    if (nil == textView)
        return;
    
    NSRange range = [textView.selectedRanges[0] rangeValue];
    NSUInteger lineNumber = [[[textView string]substringToIndex:range.location]componentsSeparatedByString:@"\n"].count;
    NSString *sourcePath = [editor.sourceCodeDocument.fileURL absoluteString];
    
    XBookmarkEntity *bookmark = [[XBookmarkEntity alloc]initWithSourcePath:sourcePath withLineNumber:lineNumber];
    [[XBookmarkModel sharedModel]toggleBookmark:bookmark];
    
    
    NSLog(@"-------------Current Bookmarks-----------------------");
    [[XBookmarkModel sharedModel].bookmarks enumerateObjectsUsingBlock:^(XBookmarkEntity *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"(%lu) Line=%ld\n\t%@",idx,obj.lineNumber,obj.sourcePath);
    }];
    
    NSLog(@"-----------------------------------------------------");
}

- (void)nextBookmark{
    
}
- (void)previousBookmark{
    
}
- (void)showBookmarks{
    
}


@end
