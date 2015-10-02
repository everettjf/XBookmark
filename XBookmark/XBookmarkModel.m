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
        self.uniqueID = [NSString stringWithFormat:@"%@;%lu",sourcePath,lineNumber];
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

-(void)insertObject:(XBookmarkEntity *)object inBookmarksAtIndex:(NSUInteger)index{
    [_bookmarks insertObject:object atIndex:index];
}
-(void)removeObjectFromBookmarksAtIndex:(NSUInteger)index{
    [_bookmarks removeObjectAtIndex:index];
}

-(void)addBookmark:(XBookmarkEntity *)bookmark{
    [self insertObject:bookmark inBookmarksAtIndex:_bookmarks.count];
}

-(void)removeBookmark:(NSString *)uniqueID{
    [_bookmarks enumerateObjectsUsingBlock:^(XBookmarkEntity *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([uniqueID isEqualToString:obj.uniqueID]){
            [self removeObjectFromBookmarksAtIndex:idx];
            *stop = YES;
        }
    }];
}

@end
