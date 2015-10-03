//
//  XBookmarkModel.m
//  XBookmark
//
//  Created by everettjf on 10/2/15.
//  Copyright © 2015 everettjf. All rights reserved.
//

#import "XBookmarkModel.h"
#import "XcodeUtil.h"

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

-(void)clearBookmarks{
    while(_bookmarks.count > 0){
        [self removeObjectFromBookmarksAtIndex:_bookmarks.count - 1];
    }
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
}

-(NSString*)currentWorkspaceSettingFilePath{
    static NSString *cachedWorkspaceFilePath = nil;
    NSString *workspaceFilePath = [XcodeUtil currentWorkspaceFilePath];
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
    
    return [[XBookmarkModel settingDirectory] stringByAppendingPathComponent:settingFileName];
}

+ (NSString*)settingDirectory
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString* settingDirectory = [(NSString*)[paths firstObject] stringByAppendingPathComponent:@"XBookmark"];
    
    NSFileManager *fileManger = [NSFileManager defaultManager];
    if (![fileManger fileExistsAtPath:settingDirectory]) {
        [fileManger createDirectoryAtPath:settingDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return settingDirectory;
}

-(void)loadOnceBookmarks{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self loadBookmarks];
    });
}

@end
