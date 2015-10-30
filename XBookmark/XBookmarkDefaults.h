//
//  XBookmarkDefaults.h
//  XBookmark
//
//  Created by everettjf on 10/31/15.
//  Copyright © 2015 everettjf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Shortcut.h"

extern NSString * const XBookmarkDefaultsShortcutToggle;
extern NSString * const XBookmarkDefaultsShortcutNext;
extern NSString * const XBookmarkDefaultsShortcutPrev;
extern NSString * const XBookmarkDefaultsShortcutShow;

@interface XBookmarkDefaults : NSObject

+(MASShortcut*)defaultShortcutToggle;
+(MASShortcut*)defaultShortcutNext;
+(MASShortcut*)defaultShortcutPrev;
+(MASShortcut*)defaultShortcutShow;

+(XBookmarkDefaults*)sharedDefaults;

@property (nonatomic,strong) MASShortcut* currentShortcutToggle;
@property (nonatomic,strong) MASShortcut* currentShortcutNext;
@property (nonatomic,strong) MASShortcut* currentShortcutPrev;
@property (nonatomic,strong) MASShortcut* currentShortcutShow;

@end
