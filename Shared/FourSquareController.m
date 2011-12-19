//
//  4sqController.m
//  PlainOAuth
//
//  Created by Jaanus Kase on 27.11.11.
//  Copyright (c) 2011 Intuit. All rights reserved.
//

#import "FoursquareController.h"
#import "OAuth.h"
#import "FoursquareLoginPopup.h"
#import "SBJson.h"

@interface FoursquareController (PrivateMethods)

- (void) resetUi;

@end

@implementation FoursquareController

@synthesize seeCheckinsButton;
@synthesize checkinsField;
@synthesize oAuth4sq;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Foursquare";
    [self resetUi];
    
}

- (void)viewDidUnload
{
    [self setSeeCheckinsButton:nil];
    [self setCheckinsField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    
    [oAuth4sq release];
    
    [seeCheckinsButton release];
    [checkinsField release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) resetUi {

    if (oAuth4sq.oauth_token_authorized) {
        UIBarButtonItem *logout = [[UIBarButtonItem alloc] initWithTitle:@"Log out"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(logout)];
        self.navigationItem.rightBarButtonItem = logout;
        [logout release];
        seeCheckinsButton.enabled = YES;

    } else {
        UIBarButtonItem *login = [[UIBarButtonItem alloc] initWithTitle:@"Log in"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(login)];
        self.navigationItem.rightBarButtonItem = login;
        [login release];
        
        seeCheckinsButton.enabled = NO;
    }
    
    checkinsField.text = @"";
    
}

#pragma mark -
#pragma mark Button actions

- (void)login {
    
    // UIActionSheet *pickFlow = [[UIActionSheet alloc] initWithTitle:@"Select Twitter login flow" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"PIN", @"URL callback", nil];
    // [pickFlow showInView:self.view];
    // [pickFlow release];
    
    // UIWebView *fourSquareLoginWebview = [[UIWebView alloc] init

    if (loginPopup) {
        [loginPopup release];
        loginPopup = nil;
    }
    
    loginPopup = [[FoursquareLoginPopup alloc] init];
    loginPopup.oAuth = oAuth4sq;
    loginPopup.delegate = self;

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginPopup];
    [self presentModalViewController:nav animated:YES];
    [nav release];
    
    
}

- (void)logout {
    [oAuth4sq forget];
    [oAuth4sq save];
    [self resetUi];
}

- (IBAction)didTapSeeCheckins:(id)sender {
    
    checkinsField.text = @"";
    
    NSString *url = [NSString stringWithFormat:@"https://api.foursquare.com/v2/users/self/checkins?v=20111218&limit=5&oauth_token=%@", oAuth4sq.oauth_token];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSHTTPURLResponse *response;
    NSError *error = nil;
    
    NSString *responseString = [[[NSString alloc] initWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error] encoding:NSUTF8StringEncoding] autorelease];
    
    NSDictionary *checkins = [responseString JSONValue];
    
    for (NSDictionary *item in [[[checkins objectForKey:@"response"] objectForKey:@"checkins"] objectForKey:@"items"]) {
        
        NSString *oneItem = [[item objectForKey:@"venue"] valueForKey:@"name"];
        NSString *shout = [item valueForKey:@"shout"];
        if (shout) {
            oneItem = [NSString stringWithFormat:@"%@. “%@”", oneItem, shout];
        }

        NSLog(@"%@", oneItem);
        
        checkinsField.text = [NSString stringWithFormat:@"%@%@\n\n", checkinsField.text, oneItem];
        
    }
    
    // NSLog(@"got response: %@", responseString);
    
}


#pragma mark -
#pragma mark oAuthLoginPopupDelegate

- (void)oAuthLoginPopupDidCancel:(UIViewController *)popup {
    [self dismissModalViewControllerAnimated:YES];        
    [loginPopup release]; loginPopup = nil;

}

- (void)oAuthLoginPopupDidAuthorize:(UIViewController *)popup {
    [self dismissModalViewControllerAnimated:YES];        
    [loginPopup release]; loginPopup = nil;
    NSLog(@"oh hai, got the token: %@", oAuth4sq.oauth_token);
    [oAuth4sq save];
    [self resetUi];
}

@end
