//
//  XBookmarkDefaults.h
//  XBookmark
//
//  Created by everettjf on 10/31/15.
//  Copyright © 2015 everettjf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Shortcut.h"

@interface XBookmarkDefaults : NSObject <NSCoding>

+(MASShortcut*)defaultShortcutToggle;
+(MASShortcut*)defaultShortcutNext;
+(MASShortcut*)defaultShortcutPrev;
+(MASShortcut*)defaultShortcutShow;
+(MASShortcut*)defaultShortcutClear;

+(XBookmarkDefaults*)sharedDefaults;

@property (nonatomic,strong) MASShortcut* currentShortcutToggle;
@property (nonatomic,strong) MASShortcut* currentShortcutNext;
@property (nonatomic,strong) MASShortcut* currentShortcutPrev;
@property (nonatomic,strong) MASShortcut* currentShortcutShow;
@property (nonatomic,strong) MASShortcut* currentShortcutClear;

@property (nonatomic,strong) NSMenuItem *toggleMenuItem;
@property (nonatomic,strong) NSMenuItem *nextMenuItem;
@property (nonatomic,strong) NSMenuItem *prevMenuItem;
@property (nonatomic,strong) NSMenuItem *showMenuItem;
@property (nonatomic,strong) NSMenuItem *clearMenuItem;

-(void)enableAllMenuShortcuts:(BOOL)enable;

-(void)synchronize;

@end
