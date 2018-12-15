//
//  BRClient.m
//  AFNetworking
//
//  Created by Alex Taffe on 11/12/18.
//

#import "BRClient.h"
@import AFNetworking;

const NSString *API_BASE = @"https://reddit.com/";
const NSString *OAUTH_BASE = @"https://oauth.reddit.com/";

@interface BRClient()
@end

@implementation BRClient
static BRClient *shared = nil;



+(BRClient *)sharedInstance {
    @synchronized([BRClient class]) {
        if (!shared)
            shared = [[self alloc] init];
        return shared;
    }
    return nil;
}

-(instancetype)init{
    self = [super init];

    if(self){
    }

    return self;
}

-(void)makeRequestWithEndpoint:(NSString *)endpoint withMethod:(NSString *)method withArguments:(nullable NSDictionary *)arguments withToken:(nullable NSString *)token success:(void (^)(id result))successBlock failure:(void (^)(NSError *error))failureBlock{

    AFHTTPSessionManager *manager = [BRClient manager];
    NSString *url = [[NSString alloc] initWithFormat:@"%@%@", token ? OAUTH_BASE : API_BASE, endpoint];

    NSMutableDictionary *addedArguments = [[NSMutableDictionary alloc] initWithDictionary:arguments];

    [addedArguments setObject:@"json" forKey:@"api_type"];
    [addedArguments setObject:@1 forKey:@"raw_json"];

    if(token){
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", token] forHTTPHeaderField:@"Authorization"];
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"oauth.reddit.com"] forHTTPHeaderField:@"Host"];
    } else {
        [manager.requestSerializer setValue:nil forHTTPHeaderField:@"Authorization"];
        [manager.requestSerializer setValue:nil forHTTPHeaderField:@"Host"];
    }

    if([method isEqualToString:@"GET"]){
        [manager GET:url parameters:addedArguments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            successBlock(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@", [task.currentRequest allHTTPHeaderFields]);
            failureBlock(error);
        }];

    } else if([method isEqualToString:@"POST"]){
        [manager POST:url parameters:addedArguments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            successBlock(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failureBlock(error);
        }];
    } else{
        [NSException raise:@"HTTPMethodNotImplemented" format:@"The HTTP method you passed is not supported, please use GET or POST"];
    }
}

+ (AFHTTPSessionManager*) manager{
    static dispatch_once_t onceToken;
    static AFHTTPSessionManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
    });

    return manager;
}

@end
