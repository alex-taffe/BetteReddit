//
//  MainViewController.m
//  BetteReddit
//
//  Created by Alex Taffe on 11/13/18.
//  Copyright © 2018 Alex Taffe. All rights reserved.
//

#import "MainViewController.h"
#import "BRUser.h"
#import "BRSubreddit.h"
#import "AppDelegate.h"
#import "BRSourceListItem.h"
#import "BRPost.h"

@import AppAuth;
@import SAMKeychain;

@interface MainViewController ()<NSOutlineViewDelegate, NSOutlineViewDataSource, NSTableViewDelegate, NSTableViewDataSource>
@property (strong, nonatomic) OIDRedirectHTTPHandler *redirectHTTPHandler;
@property (strong, nonatomic) AppDelegate *appDelegate;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.appDelegate = [[NSApplication sharedApplication] delegate];
}



- (IBAction)loginAction:(id)sender {
    static NSString *const kSuccessURLString = @"alextaffe.BetteReddit://oauth2redirect/example-provider";
    NSURL *successURL = [NSURL URLWithString:kSuccessURLString];

    NSURL *authorizationEndpoint = [NSURL URLWithString:@"https://www.reddit.com/api/v1/authorize"];
    NSURL *tokenEndpoint = [NSURL URLWithString:@"https://www.reddit.com/api/v1/access_token"];

    OIDServiceConfiguration *configuration =
    [[OIDServiceConfiguration alloc]
     initWithAuthorizationEndpoint:authorizationEndpoint
     tokenEndpoint:tokenEndpoint];

    // Starts a loopback HTTP redirect listener to receive the code.  This needs to be started first,
    // as the exact redirect URI (including port) must be passed in the authorization request.
    self.redirectHTTPHandler = [[OIDRedirectHTTPHandler alloc] initWithSuccessURL:successURL];
    NSURL *redirectURI = [self.redirectHTTPHandler startHTTPListener:nil];
    NSLog(@"%@", redirectURI);

    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *url = [bundle URLForResource:@"testing-user" withExtension:@"plist"];
    NSDictionary *userDict = [[NSDictionary alloc] initWithContentsOfURL:url];

    // builds authentication request
    OIDAuthorizationRequest *request =
    [[OIDAuthorizationRequest alloc] initWithConfiguration:configuration
                                                  clientId:userDict[@"client_id"]
                                              clientSecret:@""
                                                    scopes:@[ @"identity", @"edit", @"flair", @"history", @"modconfig", @"modflair", @"modlog", @"modposts", @"modwiki", @"mysubreddits", @"privatemessages", @"read", @"report", @"save", @"submit", @"subscribe", @"vote", @"wikiedit", @"wikiread" ]
                                               redirectURL:redirectURI
                                              responseType:OIDResponseTypeCode
                                      additionalParameters:@{
                                                             @"duration": @"permanent"
                                                             }];
    // performs authentication request
    __weak __typeof(self) weakSelf = self;
    self.redirectHTTPHandler.currentAuthorizationFlow =
    [OIDAuthState authStateByPresentingAuthorizationRequest:request
                                                   callback:^(OIDAuthState *_Nullable authState,
                                                              NSError *_Nullable error) {
                                                       // Brings this app to the foreground.
                                                       [[NSRunningApplication currentApplication]
                                                        activateWithOptions:(NSApplicationActivateAllWindows |
                                                                             NSApplicationActivateIgnoringOtherApps)];

                                                       // Processes the authorization response.
                                                       if (authState) {
                                                           BRUser *loggedInUser = [[BRUser alloc] initWithAccessToken:authState];
                                                           [loggedInUser loadUserDetails:^{
                                                               NSData *serialized = [NSKeyedArchiver archivedDataWithRootObject:authState];
                                                               [SAMKeychain setPasswordData:serialized forService:@"reddit" account:loggedInUser.username];
                                                               [self.appDelegate.loggedinUsers addObject:loggedInUser];
                                                           }];

                                                       } else {
                                                           NSLog(@"Authorization error: %@", error.localizedDescription);
                                                       }
                                                       //[weakSelf setAuthState:authState];
                                                   }];
}

@end
