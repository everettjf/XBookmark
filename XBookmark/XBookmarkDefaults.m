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
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.currentShortcutToggle forKey:kXBookmarkDefaultsShortcutToggle];
    [aCoder encodeObject:self.currentShortcutNext forKey:kXBookmarkDefaultsShortcutNext];
    [aCoder encodeObject:self.currentShortcutPrev forKey:kXBookmarkDefaultsShortcutPrev];
    [aCoder encodeObject:self.currentShortcutShow forKey:kXBookmarkDefaultsShortcutShow];
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
