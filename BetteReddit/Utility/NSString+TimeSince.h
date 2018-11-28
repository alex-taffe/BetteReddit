//
//  NSString+TimeSince.h
//  BetteReddit
//
//  Created by Alex Taffe on 11/28/18.
//  Copyright © 2018 Alex Taffe. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface NSString (TimeSince)

+(NSString *)timeSinceDate:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
