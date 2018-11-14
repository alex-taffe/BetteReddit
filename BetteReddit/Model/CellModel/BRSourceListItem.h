//
//  BRSourceListItem.h
//  BetteReddit
//
//  Created by Alex Taffe on 11/13/18.
//  Copyright © 2018 Alex Taffe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BRSourceListItem : NSObject{
    NSString *title;
    NSString *identifier; //This is required to differentiate if a Item is header/Group By object or a data item
    NSImage  *icon;       //This is required as an image placeholder for image representation for each item
    NSArray  *children;
}

@property (nonatomic, retain)       NSString *title;
@property (nonatomic, retain)       NSString *identifier;
@property (nonatomic, retain, nullable)       NSImage  *icon;
@property (nonatomic, retain)       NSArray  *children;

//Convenience methods
+ (id)itemWithTitle:(NSString*)aTitle identifier:(NSString*)anIdentifier;
+ (id)itemWithTitle:(NSString*)aTitle identifier:(NSString*)anIdentifier icon:(nullable NSImage*)anIcon;

- (BOOL)hasChildren;
- (BOOL)hasIcon;

@end

NS_ASSUME_NONNULL_END
