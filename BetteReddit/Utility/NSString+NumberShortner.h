//
//  NSString+NumberShortner.h
//  BetteReddit
//
//  Created by Alex Taffe on 11/23/18.
//  Copyright © 2018 Alex Taffe. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface NSString (NumberShortner)
+(NSString *)shortenedStringWithInt:(NSInteger)number;
@end

NS_ASSUME_NONNULL_END
