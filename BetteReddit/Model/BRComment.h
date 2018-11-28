//
//  BRComment.h
//  BetteReddit
//
//  Created by Alex Taffe on 11/14/18.
//  Copyright © 2018 Alex Taffe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRUser.h"

//forward declare BRUser
@class BRUser;

NS_ASSUME_NONNULL_BEGIN

@interface BRComment : NSObject

@property (strong, nonatomic) NSString *body; //HTML of the comment
@property (strong, atomic) NSMutableArray<BRComment *> *children;
@property (strong, nonatomic) NSString *itemID; //example: eannynk
@property (strong, nonatomic) NSNumber *score; //Total score of the comment
@property (strong, nonatomic) NSString *internalName; //example: t1_eannynk
@property (strong, nonatomic) BRUser *poster;
@property (nonatomic) int likes;

-(instancetype)initWithDictionary:(id)dict;
-(void)updateVote:(int)likes onComplete:(void (^)(void))onComplete;

@end

NS_ASSUME_NONNULL_END
