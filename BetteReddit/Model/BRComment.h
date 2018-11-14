//
//  BRComment.h
//  BetteReddit
//
//  Created by Alex Taffe on 11/14/18.
//  Copyright © 2018 Alex Taffe. All rights reserved.
//

#ifndef __BRCOMMENT_H
#define __BRCOMMENT_H

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BRComment : NSObject

@property (strong, nonatomic) NSString *body;
@property (strong, nonatomic) NSMutableArray<BRComment *> *children;
@property (strong, nonatomic) NSString *itemID;

-(instancetype)initWithDictionary:(id)dict;

@end

NS_ASSUME_NONNULL_END

#endif
