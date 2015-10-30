//
//  XBookmarkDefaults.m
//  XBookmark
//
//  Created by everettjf on 10/31/15.
//  Copyright © 2015 everettjf. All rights reserved.
//

#import "XBookmarkDefaults.h"

@implementation XBookmarkDefaults

+(MASShortcut *)defaultShortcutToggle{
    return [MASShortcut shortcutWithKeyCode:kVK_F3 modifierFlags:0];
}
+(MASShortcut *)defaultShortcutNext{
    return [MASShortcut shortcutWithKeyCode:kVK_F3 modifierFlags:NSCommandKeyMask];
}
+(MASShortcut *)defaultShortcutPrev{
    return [MASShortcut shortcutWithKeyCode:kVK_F3 modifierFlags:NSShiftKeyMask | NSControlKeyMask];
}
+(MASShortcut *)defaultShortcutShow{
    return [MASShortcut shortcutWithKeyCode:kVK_F3 modifierFlags:NSShiftKeyMask];
}

+(XBookmarkDefaults *)sharedDefaults{
    static XBookmarkDefaults *inst;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        inst = [[XBookmarkDefaults alloc]init];
        [inst load];
    });
    return inst;
}

-(void)load{
    // Load from file
    // Todo
    
    // if failed , load default
    self.currentShortcutToggle = [XBookmarkDefaults defaultShortcutToggle];
    self.currentShortcutNext = [XBookmarkDefaults defaultShortcutNext];
    self.currentShortcutPrev = [XBookmarkDefaults defaultShortcutPrev];
    self.currentShortcutShow = [XBookmarkDefaults defaultShortcutShow];
}

@end
