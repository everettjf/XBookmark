//
//  XBookmarkModel.h
//  XBookmark
//
//  Created by everettjf on 10/2/15.
//  Copyright © 2015 everettjf. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XBookmarkEntity : NSObject<NSCoding>
@property (nonatomic,strong) NSString *sourcePath;
@property (nonatomic,assign) NSUInteger lineNumber;
@property (nonatomic,strong) NSString *comment;

-(instancetype)initWithSourcePath:(NSString*)sourcePath withLineNumber:(NSUInteger)lineNumber;
@end


@interface XBookmarkModel : NSObject

+(XBookmarkModel *)sharedModel;

@property (nonatomic,strong,readonly) NSMutableArray *bookmarks;

-(void)addBookmark:(XBookmarkEntity*)bookmark;
-(void)removeBookmark:(NSString*)sourcePath lineNumber:(NSUInteger)lineNumber;
-(BOOL)hasBookmark:(NSString*)sourcePath lineNumber:(NSUInteger)lineNumber;
-(void)clearBookmarks;

-(BOOL)toggleBookmark:(XBookmarkEntity*)bookmark;

-(void)saveBookmarks;
-(void)loadBookmarks;

-(void)loadOnceBookmarks;


@end


