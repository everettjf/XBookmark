//
//  XBookmarkModel.m
//  XBookmark
//
//  Created by everettjf on 10/2/15.
//  Copyright © 2015 everettjf. All rights reserved.
//

#import "XBookmarkModel.h"

@implementation XBookmarkEntity

-(instancetype)initWithSourcePath:(NSString *)sourcePath withLineNumber:(NSUInteger)lineNumber{
    self = [super init];
    if(self){
        self.sourcePath = sourcePath;
        self.lineNumber = lineNumber;
        self.comment = @"";
    }
    return self;
}

@end

@interface XBookmarkModel ()

@end

@implementation XBookmarkModel

+(XBookmarkModel *)sharedModel{
    static XBookmarkModel *inst;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        inst = [[XBookmarkModel alloc]init];
    });
    return inst;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.bookmarks = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)insertObject:(XBookmarkEntity *)object inBookmarksAtIndex:(NSUInteger)index{
    [_bookmarks insertObject:object atIndex:index];
}
-(void)removeObjectFromBookmarksAtIndex:(NSUInteger)index{
    [_bookmarks removeObjectAtIndex:index];
}

-(void)addBookmark:(XBookmarkEntity *)bookmark{
    [self insertObject:bookmark inBookmarksAtIndex:0];
}

-(void)removeBookmark:(NSString *)sourcePath lineNumber:(NSUInteger)lineNumber{
    [_bookmarks enumerateObjectsUsingBlock:^(XBookmarkEntity *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([sourcePath isEqualToString:obj.sourcePath] && lineNumber == obj.lineNumber){
            [self removeObjectFromBookmarksAtIndex:idx];
            *stop = YES;
        }
    }];
}

-(BOOL)hasBookmark:(NSString *)sourcePath lineNumber:(NSUInteger)lineNumber{
    __block BOOL has = NO;
    [_bookmarks enumerateObjectsUsingBlock:^(XBookmarkEntity *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([sourcePath isEqualToString:obj.sourcePath] && lineNumber == obj.lineNumber){
            has = YES;
            *stop = YES;
        }
    }];
    return has;
}
-(BOOL)toggleBookmark:(XBookmarkEntity *)bookmark{
    if([self hasBookmark:bookmark.sourcePath lineNumber:bookmark.lineNumber]){
        [self removeBookmark:bookmark.sourcePath lineNumber:bookmark.lineNumber];
        return YES;
    }
    [self addBookmark:bookmark];
    return NO;
}

@end
