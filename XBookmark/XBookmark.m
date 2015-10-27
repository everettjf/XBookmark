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
#import "XBookmarkWindowController.h"

@interface XBookmark()

@property (nonatomic, strong, readwrite) NSBundle *bundle;
@property (nonatomic, strong) XBookmarkWindowController *windowController;

@property (nonatomic, assign) NSUInteger currentBookmarkIndex;

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
        
        // default to the first bookmark (if have bookmarks)
        self.currentBookmarkIndex = 0;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didApplicationFinishLaunchingNotification:)
                                                     name:NSApplicationDidFinishLaunchingNotification
                                                   object:nil];
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationLog:) name:nil object:nil];
    }
    return self;
}
//- (void)notificationLog:(NSNotification *)notify
//{
////    NSLog(@"notify name = %@",notify.name);
//}

- (void)didApplicationFinishLaunchingNotification:(NSNotification*)noti
{
    //removeObserver
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];
    
	unichar cf3 = NSF5FunctionKey;
	NSString *f3 = [NSString stringWithCharacters:&cf3 length:1];
    
    NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
    if (menuItem) {
        [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
        
        NSMenuItem *mainMenu = [[menuItem submenu]addItemWithTitle:@"XBookmark" action:nil keyEquivalent:@""];
        NSMenu *submenu = [[NSMenu alloc]init];
        mainMenu.submenu = submenu;
        
        {
            NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"Toggle Bookmark" action:@selector(toggleBookmark) keyEquivalent:f3];
            [actionMenuItem setKeyEquivalentModifierMask:0];
            [actionMenuItem setTarget:self];
            [[mainMenu submenu] addItem:actionMenuItem];
        }
        {
            NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"Next Bookmark" action:@selector(nextBookmark) keyEquivalent:f3];
            [actionMenuItem setKeyEquivalentModifierMask:NSCommandKeyMask];
            [actionMenuItem setTarget:self];
            [[mainMenu submenu] addItem:actionMenuItem];
        }
        {
            NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"Previous Bookmark" action:@selector(previousBookmark) keyEquivalent:f3];
            [actionMenuItem setKeyEquivalentModifierMask:NSShiftKeyMask | NSControlKeyMask];
            [actionMenuItem setTarget:self];
            [[mainMenu submenu] addItem:actionMenuItem];
        }
        {
            NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"Show Bookmarks" action:@selector(showBookmarks) keyEquivalent:f3];
            [actionMenuItem setKeyEquivalentModifierMask:NSShiftKeyMask];
            [actionMenuItem setTarget:self];
            [[mainMenu submenu] addItem:actionMenuItem];
        }
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)toggleBookmark
{
    [[XBookmarkModel sharedModel]loadOnceBookmarks];
    
    IDESourceCodeEditor* editor = [XcodeUtil currentEditor];
    if ([editor isKindOfClass:[IDEEditorEmpty class]]) {
        return;
    }
    NSTextView* textView = editor.textView;
    if (nil == textView)
        return;
    
    NSRange range = [textView.selectedRanges[0] rangeValue];
    NSUInteger lineNumber = [[[textView string]substringToIndex:range.location]componentsSeparatedByString:@"\n"].count;
    
    // length of "file://" is 7
    NSString *sourcePath = [[editor.sourceCodeDocument.fileURL absoluteString] substringFromIndex:7];
    
    XBookmarkEntity *bookmark = [[XBookmarkEntity alloc]initWithSourcePath:sourcePath withLineNumber:lineNumber];
    [[XBookmarkModel sharedModel]toggleBookmark:bookmark];
    
    [[XBookmarkModel sharedModel]saveBookmarks];
    
    // point to the new added bookmark
    self.currentBookmarkIndex = [XBookmarkModel sharedModel].bookmarks.count - 1;
}

- (void)nextBookmark{
    [[XBookmarkModel sharedModel]loadOnceBookmarks];
    
    XBookmarkModel *model = [XBookmarkModel sharedModel];
    if(model.bookmarks.count == 0)
        return;
    NSUInteger nextIndex = self.currentBookmarkIndex + 1;
    if(nextIndex >= model.bookmarks.count){
        // 如果超了就默认最后一个
        nextIndex = model.bookmarks.count - 1;
    }
    
    XBookmarkEntity *bookmark = [model.bookmarks objectAtIndex:nextIndex];
    [XcodeUtil openSourceFile:bookmark.sourcePath highlightLineNumber:bookmark.lineNumber];
    self.currentBookmarkIndex = nextIndex;
}
- (void)previousBookmark{
    [[XBookmarkModel sharedModel]loadOnceBookmarks];
    
    XBookmarkModel *model = [XBookmarkModel sharedModel];
    if(model.bookmarks.count == 0)
        return;
    NSUInteger previousIndex;
    if(self.currentBookmarkIndex == 0){
        previousIndex = 0;
    }else{
        previousIndex = self.currentBookmarkIndex - 1;
    }
    if(previousIndex >= model.bookmarks.count){
        previousIndex = model.bookmarks.count - 1;
    }
    
    XBookmarkEntity *bookmark = [model.bookmarks objectAtIndex:previousIndex];
    [XcodeUtil openSourceFile:bookmark.sourcePath highlightLineNumber:bookmark.lineNumber];
    self.currentBookmarkIndex = previousIndex;
}
- (void)showBookmarks{
    [[XBookmarkModel sharedModel]loadOnceBookmarks];
    
    if(self.windowController.window.isVisible){
        [self.windowController.window close];
    }else{
        if(self.windowController == nil){
            // Remember the current IDE workspace window controller
            [XcodeUtil currentIDEWorkspaceWindowController];
            
            self.windowController = [[XBookmarkWindowController alloc]initWithWindowNibName:@"XBookmarkWindowController"];
        }
        
        self.windowController.window.title = [[XcodeUtil currentWorkspaceDocument].displayName stringByDeletingLastPathComponent];
        [self.windowController.window makeKeyAndOrderFront:nil];
        [self.windowController refreshBookmarks];
    }
}


@end
