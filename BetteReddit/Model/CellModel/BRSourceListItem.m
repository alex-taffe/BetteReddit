//
//  BRSourceListItem.m
//  BetteReddit
//
//  Created by Alex Taffe on 11/13/18.
//  Copyright © 2018 Alex Taffe. All rights reserved.
//

#import "BRSourceListItem.h"

@implementation BRSourceListItem

@synthesize title;
@synthesize identifier;
@synthesize icon;
@synthesize children;

+ (id)itemWithTitle:(NSString*)aTitle identifier:(NSString*)anIdentifier{
    //convenience method for creating a Source List Item without an icon. Ideal for Group headers
    BRSourceListItem *item = [BRSourceListItem itemWithTitle:aTitle identifier:anIdentifier icon:nil];
    return item;
}

+ (id)itemWithTitle:(NSString*)aTitle identifier:(NSString*)anIdentifier icon:(NSImage*)anIcon{
    BRSourceListItem *item = [[BRSourceListItem alloc] init];
    [item setTitle:aTitle];
    [item setIdentifier:anIdentifier];
    [item setIcon:anIcon];
    return item;
}

- (BOOL)hasChildren{
    return [children count]>0;
}

- (BOOL)hasIcon{
    return icon!=nil;
}

@end
