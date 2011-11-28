//
//  Master.m
//  PlainOAuth
//
//  Created by Jaanus Kase on 27.11.11.
//  Copyright (c) 2011 Intuit. All rights reserved.
//

#import "Master.h"
#import "OAuthTwitter.h"
#import "OAuthConsumerCredentials.h"
#import "TwitterController.h"

@implementation Master
@synthesize twitterAuthStatus;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        oAuthTwitter = [[OAuthTwitter alloc] initWithConsumerKey:OAUTH_TWITTER_CONSUMER_KEY andConsumerSecret:OAUTH_TWITTER_CONSUMER_SECRET];
        [oAuthTwitter load];
        
        twitterController = [[TwitterController alloc] initWithNibName:@"TwitterController" bundle:nil];
        twitterController.oAuthTwitter = oAuthTwitter;
        
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
    self.title = @"PlainOAuth";

    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setTwitterAuthStatus:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)didTapTwitter:(id)sender {
    [self.navigationController pushViewController:twitterController animated:YES];

    
}
- (void)dealloc {
    [oAuthTwitter release];
    [twitterAuthStatus release];
    [twitterController release];
    [super dealloc];
}


#pragma mark -
#pragma mark Custom UI

- (void) resetUi {
    if (oAuthTwitter.oauth_token_authorized) {
        twitterAuthStatus.text = [NSString stringWithFormat:@"Signed in as %@", oAuthTwitter.screen_name];
    } else {
        twitterAuthStatus.text = @"Not signed in.";
    }
}

- (void)handleOAuthVerifier:(NSString *)oauth_verifier {
    [twitterController handleOAuthVerifier:oauth_verifier];
}

#pragma mark -
#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {

    // showing self. reset the ui.
    if ([viewController isKindOfClass:[self class]]) {
        [self resetUi];
    }
        
}

@end
