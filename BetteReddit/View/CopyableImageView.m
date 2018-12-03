//
//  CopyableImageView.m
//  BetteReddit
//
//  Created by Alex Taffe on 12/3/18.
//  Copyright © 2018 Alex Taffe. All rights reserved.
//

#import "CopyableImageView.h"

@implementation CopyableImageView

- (void)rightMouseUp:(NSEvent *)event{
    NSMenu *theMenu = [[NSMenu alloc] initWithTitle:@"Contextual Menu"];

    [theMenu insertItemWithTitle:@"Copy Link" action:@selector(copyLink) keyEquivalent:@"" atIndex:0];
    [theMenu insertItemWithTitle:@"Copy Image" action:@selector(copyImage) keyEquivalent:@"" atIndex:1];


    [NSMenu popUpContextMenu:theMenu withEvent:event forView:self];
}

#pragma mark - Right click options
-(void)copyLink{
    [[NSPasteboard generalPasteboard] clearContents];
    [[NSPasteboard generalPasteboard] setString:self.post.url forType:NSPasteboardTypeString];
}

-(void)copyImage{
    [[NSPasteboard generalPasteboard] clearContents];
    [[NSPasteboard generalPasteboard] setData:[self.image TIFFRepresentation] forType:NSPasteboardTypeTIFF];
}

@end
