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
@property (strong, nonatomic) NSMutableArray<BRSourceListItem *> *sourceItems;
@property (strong, nonatomic) NSMutableArray<BRPost *> *posts;
@property (strong) IBOutlet NSOutlineView *outlineView;
@property (strong) IBOutlet NSTableView *postListView;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.appDelegate = [[NSApplication sharedApplication] delegate];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newLoggedInUser)
                                                 name:@"LoggedInUserRefresh"
                                               object:nil];

    self.sourceItems = [[NSMutableArray alloc] init];
    self.posts = [[NSMutableArray alloc] init];

    self.outlineView.delegate = self;
    self.outlineView.dataSource = self;

    self.postListView.delegate = self;
    self.postListView.dataSource = self;
}

-(void)newLoggedInUser{
    [self.sourceItems removeAllObjects];
    [self.appDelegate.currentUser loadSubscriptions:^{
        for(BRSubreddit *subreddit in self.appDelegate.currentUser.subscriptions){
            [self.sourceItems addObject:[BRSourceListItem itemWithTitle:subreddit.name identifier:subreddit.name]];
        }
        dispatch_async(dispatch_get_main_queue(),^(void){
            [self.outlineView reloadData];
        });

    }];



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

#pragma mark - OutlineView data

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item{
    if(item == nil){
        return [self.sourceItems count];
    } else {
        return [[item children] count];
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item{
    return [item hasChildren];
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item{
    if(item == nil){
        return [self.sourceItems objectAtIndex:index];
    } else {
        return [[item children] objectAtIndex:index];
    }
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item{
    return [item title];
}

- (void)outlineView:(NSOutlineView *)outlineView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn byItem:(id)item{
    // This method needs to be implemented if the SourceList is editable. e.g Changing the name of a Playlist in iTunes
    //[item setTitle:object];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item{
    //Making the Source List Items Non Editable
    return NO;
}

- (NSCell *)outlineView:(NSOutlineView *)outlineView dataCellForTableColumn:(NSTableColumn *)tableColumn item:(id)item{
    NSInteger row = [outlineView rowForItem:item];
    return [tableColumn dataCellForRow:row];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item{
    return NO;

}

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    // Different Source List Items can have completely different UI based on the Item Type. In this sample we have only two types of views (Header and Data Cell). One can have multiple types of data cells.
    // If there is a need to have more than one type of Data Cells. It can be done in this method
    NSTableCellView *view = [outlineView makeViewWithIdentifier:@"DataCell" owner:self];
    [[view imageView] setImage:[item icon]];
    [[view textField] setStringValue:[item title]];
    return view;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item{
    //Here we are restricting users for selecting the Header/ Groups. Only the Data Cell Items can be selected. The group headers can only be shown or hidden.
    return YES;
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification{
    NSInteger selectedIndex = [self.outlineView selectedRow];
    [self.posts removeAllObjects];
    [self.appDelegate.currentUser.subscriptions[selectedIndex] loadSubredditPosts:^{
        [self.posts addObjectsFromArray:self.appDelegate.currentUser.subscriptions[selectedIndex].posts];
        [self.postListView reloadData];
    }];
}

#pragma mark - PostView data

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return self.posts.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    NSTableCellView *cell = [tableView makeViewWithIdentifier:@"postCell" owner:nil];
    cell.textField.stringValue = self.posts[row].title;

    return cell;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification{
    NSInteger selection = self.postListView.selectedRow;
    [self.posts[selection] loadPostComments:^{

    }];
}

@end
