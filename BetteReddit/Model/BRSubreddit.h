//
//  BRSubreddit.h
//  BetteRedditKit
//
//  Created by Alex Taffe on 6/2/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BRSubreddit : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *internalName;

-(instancetype)initWithName:(NSString *)name;

@end


NS_ASSUME_NONNULL_END
