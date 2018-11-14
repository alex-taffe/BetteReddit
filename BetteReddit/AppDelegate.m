//
//  AppDelegate.m
//  BetteReddit
//
//  Created by Alex Taffe on 5/27/18.
//  Copyright © 2018 Alex Taffe. All rights reserved.
//

#import "AppDelegate.h"
@import SAMKeychain;
@import AppAuth;

@interface AppDelegate ()

- (IBAction)saveAction:(id)sender;
@property (strong, nonatomic) OIDRedirectHTTPHandler *redirectHTTPHandler;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application

    self.loggedinUsers = [[NSMutableArray alloc] init];

    NSArray *test = [SAMKeychain accountsForService:@"reddit"];
    __weak __typeof(self) weakSelf = self;

    dispatch_semaphore_t semaphore = dispatch_semaphore_create(test.count - 1);
    for(NSDictionary *account in test){
        NSData *authStateData = [SAMKeychain passwordDataForService:@"reddit" account:account[@"acct"]];
        OIDAuthState *authState = (OIDAuthState *) [NSKeyedUnarchiver unarchiveObjectWithData:authStateData];

        BRUser *user = [[BRUser alloc] initWithAccessToken:authState];
        [user loadUserDetails:^{
            [weakSelf.loggedinUsers addObject:user];
            dispatch_semaphore_signal(semaphore);
        }];
    }
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void){
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        self.currentUser = self.loggedinUsers.firstObject;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoggedInUserRefresh" object:weakSelf];
    });


}
- (IBAction)newSignin:(id)sender {
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
    NSURL *url = [bundle URLForResource:@"config" withExtension:@"plist"];
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
                                                               [weakSelf.loggedinUsers addObject:loggedInUser];
                                                               [[NSNotificationCenter defaultCenter] postNotificationName:@"LoggedInUserRefresh" object:weakSelf];
                                                           }];

                                                       } else {
                                                           NSLog(@"Authorization error: %@", error.localizedDescription);
                                                       }
                                                       //[weakSelf setAuthState:authState];
                                                   }];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"BetteReddit"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving and Undo support

- (IBAction)saveAction:(id)sender {
    // Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
    NSManagedObjectContext *context = self.persistentContainer.viewContext;

    if (![context commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }
    
    NSError *error = nil;
    if (context.hasChanges && ![context save:&error]) {
        // Customize this code block to include application-specific recovery steps.              
        [[NSApplication sharedApplication] presentError:error];
    }
}

- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window {
    // Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
    return self.persistentContainer.viewContext.undoManager;
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    // Save changes in the application's managed object context before the application terminates.
    NSManagedObjectContext *context = self.persistentContainer.viewContext;

    if (![context commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }
    
    if (!context.hasChanges) {
        return NSTerminateNow;
    }
    
    NSError *error = nil;
    if (![context save:&error]) {

        // Customize this code block to include application-specific recovery steps.
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }

        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertSecondButtonReturn) {
            return NSTerminateCancel;
        }
    }

    return NSTerminateNow;
}

@end
