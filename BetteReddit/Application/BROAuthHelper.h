//
//  BROAuthHelper.h
//  BetteReddit
//
//  Created by Alex Taffe on 11/14/18.
//  Copyright © 2018 Alex Taffe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BROAuthHelper : NSObject

+(void)performOAuthAction:(void (^)(NSString *authToken))onComplete;

@end

NS_ASSUME_NONNULL_END
