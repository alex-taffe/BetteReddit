//
//  BRClient.h
//  AFNetworking
//
//  Created by Alex Taffe on 11/12/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BRClient : NSObject

/**
 Retrieves the shared instance of the BRClient

 @return the shared instance
 */
+(BRClient *)sharedInstance;


/**
 Make a request to reddit

 @param endpoint the end point to request with no leading /
 @param method the HTTP method to use, current GET and POST are supported
 @param arguments any arguments that need to be passsed to the endpoint
 @param successBlock on success
 @param failureBlock on failure
 */
-(void)makeRequestWithEndpoint:(NSString *)endpoint withMethod:(NSString *)method withArguments:(nullable NSDictionary *)arguments withToken:(nullable NSString *)token success:(void (^)(id result))successBlock failure:(void (^)(NSError *error))failureBlock;

@end

NS_ASSUME_NONNULL_END
