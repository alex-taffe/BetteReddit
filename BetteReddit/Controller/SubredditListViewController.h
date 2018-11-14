//
//  SubredditListViewController.h
//  BetteReddit
//
//  Created by Alex Taffe on 11/14/18.
//  Copyright © 2018 Alex Taffe. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface SubredditListViewController : NSViewController
@property (strong) IBOutlet NSTableView *subscriptionListView;

@end

NS_ASSUME_NONNULL_END
