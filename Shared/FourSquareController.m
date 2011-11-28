//
//  4sqController.m
//  PlainOAuth
//
//  Created by Jaanus Kase on 27.11.11.
//  Copyright (c) 2011 Intuit. All rights reserved.
//

#import "FoursquareController.h"
#import "OAuth4sq.h"
#import "FoursquareLoginPopup.h"

@interface FoursquareController (PrivateMethods)

- (void) resetUi;

@end

@implementation FoursquareController

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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    
    [oAuth4sq release];
    
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

    } else {
        UIBarButtonItem *login = [[UIBarButtonItem alloc] initWithTitle:@"Log in"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(login)];
        self.navigationItem.rightBarButtonItem = login;
        [login release];
    }
    
}

#pragma mark -
#pragma mark Button actions

- (void)login {
    
    // UIActionSheet *pickFlow = [[UIActionSheet alloc] initWithTitle:@"Select Twitter login flow" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"PIN", @"URL callback", nil];
    // [pickFlow showInView:self.view];
    // [pickFlow release];
    
    // UIWebView *fourSquareLoginWebview = [[UIWebView alloc] init

    if (!loginPopup) {
        loginPopup = [[FoursquareLoginPopup alloc] init];
        loginPopup.delegate = self;
    }
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginPopup];
    [self presentModalViewController:nav animated:YES];
    [nav release];
    
    
}

- (void)logout {
    [oAuth4sq forget];
    [oAuth4sq save];
    [self resetUi];
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
    
}

@end
