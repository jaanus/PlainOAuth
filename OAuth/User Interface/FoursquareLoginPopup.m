//
//  FoursquareLoginPopup.m
//  PlainOAuth
//
//  Created by Jaanus Kase on 27.11.11.
//  Copyright (c) 2011 Intuit. All rights reserved.
//

#import "FoursquareLoginPopup.h"
#import "OAuthConsumerCredentials.h"
#import "OAuth.h"

@implementation FoursquareLoginPopup

@synthesize delegate, oAuth;

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

- (void) dealloc {
    [oAuth release];
    [super dealloc];
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Sign in to Foursquare";
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"Cancel"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(cancel)];	
	self.navigationItem.leftBarButtonItem = cancelButton;
	[cancelButton release];
    
    CGRect appFrame = [UIScreen mainScreen].applicationFrame;    
    webView = [[[UIWebView alloc] initWithFrame:CGRectMake(0,0,appFrame.size.width,appFrame.size.height)] autorelease];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webView.delegate = self;
    [self.view addSubview:webView];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://foursquare.com/oauth2/authenticate?client_id=%@&response_type=token&redirect_uri=%@", OAUTH_FOURSQUARE_CONSUMER_KEY, @"plainoauth://handleFoursquareLogin"]]]];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Button actions

- (void)cancel {    
	[self.delegate oAuthLoginPopupDidCancel:self];
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webview shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"webview should load request: %@", request);
    
    NSString *URLString = [[request URL] absoluteString];
        
    if ([URLString rangeOfString:@"access_token="].location != NSNotFound) {
        
        
        NSString *accessToken = [[URLString componentsSeparatedByString:@"="] lastObject];

        NSLog(@"yowza, got token: %@ from url %@", accessToken, URLString);

        oAuth.oauth_token = accessToken;
        oAuth.oauth_token_authorized = YES;
        [oAuth save];
        [self.delegate oAuthLoginPopupDidAuthorize:self];
        return NO;
    }
    
    
    return YES;
}

@end
