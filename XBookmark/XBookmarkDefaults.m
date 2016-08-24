//
//  XBookmarkDefaults.m
//  XBookmark
//
//  Created by everettjf on 10/31/15.
//  Copyright © 2015 everettjf. All rights reserved.
//

#import "XBookmarkDefaults.h"
#import "XBookmarkUtil.h"

static NSString * const kXBookmarkDefaultsShortcutToggle = @"XBookmarkDefaultsShortcutToggle";
static NSString * const kXBookmarkDefaultsShortcutNext = @"XBookmarkDefaultsShortcutNext";
static NSString * const kXBookmarkDefaultsShortcutPrev = @"XBookmarkDefaultsShortcutPrev";
static NSString * const kXBookmarkDefaultsShortcutShow = @"XBookmarkDefaultsShortcutShow";
static NSString * const kXBookmarkDefaultsShortcutClear = @"XBookmarkDefaultsShortcutClear";

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
+(MASShortcut *)defaultShortcutClear{
    return [MASShortcut shortcutWithKeyCode:kVK_F3 modifierFlags:NSShiftKeyMask |NSCommandKeyMask];
}

+(XBookmarkDefaults *)sharedDefaults{
    static XBookmarkDefaults *inst;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        inst = [NSKeyedUnarchiver unarchiveObjectWithFile:[XBookmarkDefaults configFilePath]];
        if(inst == nil){
            inst = [[XBookmarkDefaults alloc]init];
        }
    });
    return inst;
}

+(NSString*)configFilePath{
    return [[XBookmarkUtil settingDirectory]stringByAppendingPathComponent:@"config"];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.currentShortcutToggle = [XBookmarkDefaults defaultShortcutToggle];
        self.currentShortcutNext = [XBookmarkDefaults defaultShortcutNext];
        self.currentShortcutPrev = [XBookmarkDefaults defaultShortcutPrev];
        self.currentShortcutShow = [XBookmarkDefaults defaultShortcutShow];
        self.currentShortcutClear = [XBookmarkDefaults defaultShortcutClear];
    }
    return self;
}

-(void)synchronize{
    [NSKeyedArchiver archiveRootObject:self toFile:[XBookmarkDefaults configFilePath]];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        self.currentShortcutToggle = [aDecoder decodeObjectForKey:kXBookmarkDefaultsShortcutToggle];
        self.currentShortcutNext = [aDecoder decodeObjectForKey:kXBookmarkDefaultsShortcutNext];
        self.currentShortcutPrev = [aDecoder decodeObjectForKey:kXBookmarkDefaultsShortcutPrev];
        self.currentShortcutShow = [aDecoder decodeObjectForKey:kXBookmarkDefaultsShortcutShow];
        self.currentShortcutClear = [aDecoder decodeObjectForKey:kXBookmarkDefaultsShortcutClear];
        
        if(!self.currentShortcutClear) self.currentShortcutClear = [XBookmarkDefaults defaultShortcutClear];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.currentShortcutToggle forKey:kXBookmarkDefaultsShortcutToggle];
    [aCoder encodeObject:self.currentShortcutNext forKey:kXBookmarkDefaultsShortcutNext];
    [aCoder encodeObject:self.currentShortcutPrev forKey:kXBookmarkDefaultsShortcutPrev];
    [aCoder encodeObject:self.currentShortcutShow forKey:kXBookmarkDefaultsShortcutShow];
    [aCoder encodeObject:self.currentShortcutClear forKey:kXBookmarkDefaultsShortcutClear];
}

-(void)enableAllMenuShortcuts:(BOOL)enable{
    if(enable){
        if(self.currentShortcutToggle){
            self.toggleMenuItem.keyEquivalent = self.currentShortcutToggle.keyCodeStringForKeyEquivalent;
            self.toggleMenuItem.keyEquivalentModifierMask = self.currentShortcutToggle.modifierFlags;
        }
        
        if(self.currentShortcutNext){
            self.nextMenuItem.keyEquivalent = self.currentShortcutNext.keyCodeStringForKeyEquivalent;
            self.nextMenuItem.keyEquivalentModifierMask = self.currentShortcutNext.modifierFlags;
        }
        
        if(self.currentShortcutPrev){
            self.prevMenuItem.keyEquivalent = self.currentShortcutPrev.keyCodeStringForKeyEquivalent;
            self.prevMenuItem.keyEquivalentModifierMask = self.currentShortcutPrev.modifierFlags;
        }
        
        if(self.currentShortcutShow){
            self.showMenuItem.keyEquivalent = self.currentShortcutShow.keyCodeStringForKeyEquivalent;
            self.showMenuItem.keyEquivalentModifierMask = self.currentShortcutShow.modifierFlags;
        }
        
        if(self.currentShortcutClear){
            self.clearMenuItem.keyEquivalent = self.currentShortcutClear.keyCodeStringForKeyEquivalent;
            self.clearMenuItem.keyEquivalentModifierMask = self.currentShortcutClear.modifierFlags;
        }
    }else{
        NSArray *menus = @[
                           self.toggleMenuItem,
                           self.nextMenuItem,
                           self.prevMenuItem,
                           self.showMenuItem,
                           self.clearMenuItem,
                           ];
        for (NSMenuItem *menu in menus){
            menu.keyEquivalent = @"";
            menu.keyEquivalentModifierMask = 0;
        }
    }
}

@end
