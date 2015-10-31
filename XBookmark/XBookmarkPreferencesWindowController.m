//
//  XBookmarkPreferencesWindowController.m
//  XBookmark
//
//  Created by everettjf on 10/30/15.
//  Copyright © 2015 everettjf. All rights reserved.
//

#import "XBookmarkPreferencesWindowController.h"
#import "Shortcut.h"
#import "XBookmarkDefaults.h"
#import "XBookmarkUtil.h"

@interface XBookmarkPreferencesWindowController ()<NSWindowDelegate>
@property (weak) IBOutlet MASShortcutView *toggleShortcutView;
@property (weak) IBOutlet MASShortcutView *nextShortcutView;
@property (weak) IBOutlet MASShortcutView *prevShortcutView;
@property (weak) IBOutlet MASShortcutView *showShortcutView;

@end

@implementation XBookmarkPreferencesWindowController

-(instancetype)init{
    return [self initWithWindowNibName:@"XBookmarkPreferencesWindowController"];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    [[XBookmarkDefaults sharedDefaults] enableAllMenuShortcuts:NO];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(windowWillClose:) name:NSWindowWillCloseNotification object:self.window];
    
    XBookmarkDefaults *config = [XBookmarkDefaults sharedDefaults];
    
    self.toggleShortcutView.shortcutValue = config.currentShortcutToggle;
    self.toggleShortcutView.shortcutValueChange = ^(MASShortcutView *sender){
        config.currentShortcutToggle = sender.shortcutValue;
        [config synchronize];
    };
    
    self.nextShortcutView.shortcutValue = config.currentShortcutNext;
    self.nextShortcutView.shortcutValueChange = ^(MASShortcutView *sender){
        config.currentShortcutNext = sender.shortcutValue;
        [config synchronize];
    };
    
    self.prevShortcutView.shortcutValue = config.currentShortcutPrev;
    self.prevShortcutView.shortcutValueChange = ^(MASShortcutView *sender){
        config.currentShortcutPrev = sender.shortcutValue;
        [config synchronize];
    };
    
    self.showShortcutView.shortcutValue = config.currentShortcutShow;
    self.showShortcutView.shortcutValueChange = ^(MASShortcutView *sender){
        config.currentShortcutShow = sender.shortcutValue;
        [config synchronize];
    };
}

-(void)windowWillClose:(NSNotification *)notification{
    [[XBookmarkDefaults sharedDefaults] enableAllMenuShortcuts:YES];
}


@end
