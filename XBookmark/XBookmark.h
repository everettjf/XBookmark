//
//  XBookmark.h
//  XBookmark
//
//  Created by everettjf on 9/26/15.
//  Copyright © 2015 everettjf. All rights reserved.
//

#import <AppKit/AppKit.h>

@class XBookmark;

static XBookmark *sharedPlugin;

@interface XBookmark : NSObject

+ (instancetype)sharedPlugin;
- (id)initWithBundle:(NSBundle *)plugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;

@end