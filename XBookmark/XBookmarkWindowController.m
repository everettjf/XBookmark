//
//  XBookmarkWindowController.m
//  XBookmark
//
//  Created by everettjf on 10/2/15.
//  Copyright © 2015 everettjf. All rights reserved.
//

#import "XBookmarkWindowController.h"
#import "XBookmarkModel.h"
#import "XcodeUtil.h"

@interface XBookmarkWindowController () <NSTableViewDelegate,NSTableViewDataSource>
@property (weak) IBOutlet NSTableView *bookmarksTableView;
@property (nonatomic,strong) NSArray *bookmarks;

@end

@implementation XBookmarkWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    if([tableColumn.identifier isEqualToString:@"BookmarkColumn"]){
        XBookmarkEntity *bookmark = [self.bookmarks objectAtIndex:row];
        NSString *description = [NSString stringWithFormat:@"%@:%lu (%@)",
                                 [bookmark.sourcePath lastPathComponent],
                                 bookmark.lineNumber,
                                 bookmark.sourcePath
                                 ];
        cellView.textField.stringValue = description;
    }
    return cellView;
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return self.bookmarks.count;
}


-(void)refreshBookmarks{
    self.bookmarks = [XBookmarkModel sharedModel].bookmarks;
    [self.bookmarksTableView reloadData];
    
//    NSLog(@"-------------Current Bookmarks-----------------------");
//    [[XBookmarkModel sharedModel].bookmarks enumerateObjectsUsingBlock:^(XBookmarkEntity *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSLog(@"(%lu) Line=%ld\n\t%@",idx,obj.lineNumber,obj.sourcePath);
//    }];
//    NSLog(@"-----------------------------------------------------");
    
}

-(XBookmarkEntity*)selectedBookmark{
    NSInteger selectedRow = self.bookmarksTableView.selectedRow;
    if(selectedRow < 0 || selectedRow >= self.bookmarks.count){
        return nil;
    }
    
    XBookmarkEntity *bookmark = [self.bookmarks objectAtIndex:selectedRow];
    return bookmark;
}

-(void)tableViewSelectionDidChange:(NSNotification *)notification{
    XBookmarkEntity *bookmark = [self selectedBookmark];
    if(nil == bookmark)
        return;
    
    // locate bookmark
    [XcodeUtil openSourceFile:bookmark.sourcePath highlightLineNumber:bookmark.lineNumber];
}

@end
