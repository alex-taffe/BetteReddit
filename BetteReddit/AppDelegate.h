//
//  AppDelegate.h
//  BetteReddit
//
//  Created by Alex Taffe on 5/27/18.
//  Copyright © 2018 Alex Taffe. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreData/CoreData.h>
#import "BRUser.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (strong, nonatomic) NSMutableArray<BRUser *> *loggedinUsers;

@end

