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


/**
 Gets a fresh OAuth access token then notifies the callback that
 we can use it

 @param onComplete callback when we have a fresh access token
 */
+(void)performOAuthAction:(void (^)(NSString *authToken))onComplete;

@end

NS_ASSUME_NONNULL_END
