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
    
    
    [self.toggleShortcutView setAssociatedUserDefaultsKey:XBookmarkDefaultsShortcutToggle];
    [self.nextShortcutView setAssociatedUserDefaultsKey:XBookmarkDefaultsShortcutNext];
    [self.prevShortcutView setAssociatedUserDefaultsKey:XBookmarkDefaultsShortcutPrev];
    [self.showShortcutView setAssociatedUserDefaultsKey:XBookmarkDefaultsShortcutShow];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(windowWillClose:) name:NSWindowWillCloseNotification object:self.window];
}

-(void)windowWillClose:(NSNotification *)notification{
    [[XBookmarkDefaults sharedDefaults] enableAllMenuShortcuts:YES];
}


@end
