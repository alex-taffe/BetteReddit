//
//  BRUser.m
//  AFNetworking
//
//  Created by Alex Taffe on 6/2/18.
//

#import "BRUser.h"
#import "BRClient.h"

@implementation BRUser

-(instancetype)init{
    self = [super init];

    if(self){
        
    }

    return self;
}

-(void)loadUserDetails:(void (^)(void))onComplete{
    
}

-(void)loginUserWithPassword:(NSString  *)password onComplete:(void (^)(bool didLogin, bool needsMFA, NSError *error))onComplete{
    NSDictionary *arguments = @{
                                @"user": self.username,
                                @"passwd": password
                                };

    [[BRClient sharedInstance] makeRequestWithEndpoint:@"login" withArguments:arguments success:^(id _Nonnull result) {
        if([result[@"errors"] count] != 0){
            //error occured
            onComplete(false, false, [NSError errorWithDomain:@"BetteRedditKit" code:42 userInfo:nil]);
        } else if([result[@"data"][@"details"] isEqualToString:@"TWO_FA_REQUIRED"]) {
            //the user needs MFA
            onComplete(false, true, nil);
        } else if(result[@"data"][@"modhash"]){
            //logged in successfully
            onComplete(true, false, nil);
        } else {
            //something went wrong
            onComplete(false, false, nil);
        }
    } failure:^(NSError * _Nonnull error) {
        onComplete(false, false, error);
    }];

}

@end
