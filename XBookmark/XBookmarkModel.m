//
//  XBookmarkModel.m
//  XBookmark
//
//  Created by everettjf on 10/2/15.
//  Copyright © 2015 everettjf. All rights reserved.
//

#import "XBookmarkModel.h"
#import "XBookmarkUtil.h"

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

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        self.sourcePath = [aDecoder decodeObjectForKey:@"sourcePath"];
        self.lineNumber = [aDecoder decodeIntegerForKey:@"lineNumber"];
        self.comment = [aDecoder decodeObjectForKey:@"comment"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_sourcePath forKey:@"sourcePath"];
    [aCoder encodeInteger:_lineNumber forKey:@"lineNumber"];
    [aCoder encodeObject:_comment forKey:@"comment"];
}

@end

@interface XBookmarkModel ()

@property (nonatomic,strong) NSMutableArray *bookmarks;

// for fast check
@property (nonatomic,strong) NSMutableSet<NSString*> *markset;

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
        self.markset = [[NSMutableSet alloc]init];
    }
    return self;
}
static inline NSString* xbookmark_HashLine(NSString*sourcePath,NSUInteger lineNumber){
    return [NSString stringWithFormat:@"%lu-%lu",lineNumber,[sourcePath hash]];
}

-(void)insertObject:(XBookmarkEntity *)object inBookmarksAtIndex:(NSUInteger)index{
    [_bookmarks insertObject:object atIndex:index];
    [_markset addObject:xbookmark_HashLine(object.sourcePath, object.lineNumber)];
}
-(void)removeObjectFromBookmarksAtIndex:(NSUInteger)index{
    XBookmarkEntity *object = [_bookmarks objectAtIndex:index];
    if(nil == object)
        return;
    [_bookmarks removeObjectAtIndex:index];
    [_markset removeObject:xbookmark_HashLine(object.sourcePath, object.lineNumber)];
}

-(void)addBookmark:(XBookmarkEntity *)bookmark{
    [self insertObject:bookmark inBookmarksAtIndex:self.bookmarks.count];
}

-(void)clearBookmarks{
    while(_bookmarks.count > 0){
        [self removeObjectFromBookmarksAtIndex:_bookmarks.count - 1];
    }
    [_markset removeAllObjects];
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
    return [_markset containsObject:xbookmark_HashLine(sourcePath, lineNumber)];
}

-(BOOL)toggleBookmark:(XBookmarkEntity *)bookmark{
    if([self hasBookmark:bookmark.sourcePath lineNumber:bookmark.lineNumber]){
        [self removeBookmark:bookmark.sourcePath lineNumber:bookmark.lineNumber];
        return YES;
    }
    [self addBookmark:bookmark];
    return NO;
}

-(void)saveBookmarks{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *workspace = [self currentWorkspaceSettingFilePath];
        if(workspace == nil)
            return;
        
        if(self.bookmarks.count == 0){
            [[NSFileManager defaultManager] removeItemAtPath:workspace error:nil];
        }else{
            [NSKeyedArchiver archiveRootObject:self.bookmarks toFile:workspace];
        }
    });
}
-(void)loadBookmarks{
    NSArray *data = [NSKeyedUnarchiver unarchiveObjectWithFile:[self currentWorkspaceSettingFilePath]];
    if(nil == data)
        return;
    
    self.bookmarks = [data mutableCopy];
    [self refreshHashset];
}
-(void)refreshHashset{
    [_markset removeAllObjects];
    [self.bookmarks enumerateObjectsUsingBlock:^(XBookmarkEntity* _Nonnull object, NSUInteger idx, BOOL * _Nonnull stop) {
        [_markset addObject:xbookmark_HashLine(object.sourcePath, object.lineNumber)];
    }];
}


-(NSString*)currentWorkspaceSettingFilePath{
    static NSString *cachedWorkspaceFilePath = nil;
    NSString *workspaceFilePath = [XBookmarkUtil currentWorkspaceFilePath];
    if(workspaceFilePath == nil){
        workspaceFilePath = cachedWorkspaceFilePath;
    }else{
        cachedWorkspaceFilePath = [workspaceFilePath copy];
    }
    
    if(workspaceFilePath == nil)
        return nil;
    
    NSString *settingFileName = [NSString stringWithFormat:@"%@-%lu.xbookmark",
                                 [workspaceFilePath lastPathComponent],
                                 [workspaceFilePath hash]
                                 ];
    
    return [[XBookmarkUtil settingDirectory] stringByAppendingPathComponent:settingFileName];
}

-(void)loadOnceBookmarks{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self loadBookmarks];
    });
}

@end
