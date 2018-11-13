//
//  BRUser.h
//  AFNetworking
//
//  Created by Alex Taffe on 6/2/18.
//

#import <Foundation/Foundation.h>


@interface BRUser : NSObject

@property (strong, nonatomic) NSString *username;

-(void)loadUserDetails:(void (^)(void))onComplete;


/**
 Tries to log the current user in with a provided password

 @param password the password to log the user in with
 @param onComplete completion handler when the request returns
 */
-(void)loginUserWithPassword:(NSString  *)password onComplete:(void (^)(bool didLogin, bool needsMFA, NSError *error))onComplete;

@end
