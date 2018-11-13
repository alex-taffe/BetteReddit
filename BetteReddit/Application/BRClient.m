//
//  BRClient.m
//  AFNetworking
//
//  Created by Alex Taffe on 11/12/18.
//

#import "BRClient.h"
@import AFNetworking;

const NSString *API_BASE = @"https://ssl.reddit.com/api/";

@interface BRClient()
@property (strong, nonatomic) AFHTTPSessionManager *manager;
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
        self.manager = [[AFHTTPSessionManager alloc] init];
    }

    return self;
}


-(void)makeRequestWithEndpoint:(NSString *)endpoint withArguments:(NSDictionary *)arguments success:(void (^)(id result))successBlock failure:(void (^)(NSError *error))failureBlock{
    NSString *url = [[NSString alloc] initWithFormat:@"%@%@", API_BASE, endpoint];

    NSMutableDictionary *addedArguments = [[NSMutableDictionary alloc] initWithDictionary:arguments];

    [addedArguments setObject:@"json" forKey:@"api_type"];

    [self.manager POST:url parameters:addedArguments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject[@"json"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error);
    }];
}

@end
