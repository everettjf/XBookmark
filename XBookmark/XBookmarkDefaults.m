//
//  XBookmarkDefaults.m
//  XBookmark
//
//  Created by everettjf on 10/31/15.
//  Copyright © 2015 everettjf. All rights reserved.
//

#import "XBookmarkDefaults.h"

NSString * const XBookmarkDefaultsShortcutToggle = @"XBookmarkDefaultsShortcutToggle";
NSString * const XBookmarkDefaultsShortcutNext = @"XBookmarkDefaultsShortcutNext";
NSString * const XBookmarkDefaultsShortcutPrev = @"XBookmarkDefaultsShortcutPrev";
NSString * const XBookmarkDefaultsShortcutShow = @"XBookmarkDefaultsShortcutShow";

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

-(void)enableAllMenuShortcuts:(BOOL)enable{
    if(enable){
        self.toggleMenuItem.keyEquivalent = self.currentShortcutToggle.keyCodeStringForKeyEquivalent;
        self.toggleMenuItem.keyEquivalentModifierMask = self.currentShortcutToggle.modifierFlags;
        
        self.nextMenuItem.keyEquivalent = self.currentShortcutNext.keyCodeStringForKeyEquivalent;
        self.nextMenuItem.keyEquivalentModifierMask = self.currentShortcutNext.modifierFlags;
        
        self.prevMenuItem.keyEquivalent = self.currentShortcutPrev.keyCodeStringForKeyEquivalent;
        self.prevMenuItem.keyEquivalentModifierMask = self.currentShortcutPrev.modifierFlags;
        
        self.showMenuItem.keyEquivalent = self.currentShortcutShow.keyCodeStringForKeyEquivalent;
        self.showMenuItem.keyEquivalentModifierMask = self.currentShortcutShow.modifierFlags;
    }else{
        NSArray *menus = @[
                           self.toggleMenuItem,
                           self.nextMenuItem,
                           self.prevMenuItem,
                           self.showMenuItem
                           ];
        for (NSMenuItem *menu in menus){
            menu.keyEquivalent = @"";
            menu.keyEquivalentModifierMask = 0;
        }
    }
}

@end
