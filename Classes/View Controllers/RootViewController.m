//
//  RootViewController.m
//
//  Created by Jaanus Kase on 16.01.10.
//  Copyright 2010. All rights reserved.
//

#import "RootViewController.h"
#import "TwitterLoginPopup.h"

@implementation RootViewController

#pragma mark Status posting: button action and HTTP request callbacks

- (IBAction)postStatus:(id)sender {
	NSString *status = statusField.text;
	NSString *whereToPost = @"https://twitter.com/statuses/update.json";
	NSString *authHeader = [oAuth oAuthHeaderForMethod:@"POST"
												andUrl:whereToPost
											 andParams:[NSDictionary dictionaryWithObject:status forKey:@"status"]];
	
	ASIFormDataRequest *request = [[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:whereToPost]] autorelease];
	[request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
	request.requestMethod = @"POST";
	[request addRequestHeader:@"Authorization" value:authHeader];
	[request setPostValue:status forKey:@"status"];
	request.delegate = self;
	spinner.hidden = NO;
	[spinner startAnimating];
	[request startAsynchronous];
}

- (void) requestFinished:(ASIHTTPRequest *)request {
	[spinner stopAnimating];
	spinner.hidden = YES;
	UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"Success"
														   message:@"The status was posted. You can see it now on the interwebs."
														  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[successAlert show];
	[successAlert release];
}

- (void) requestFailed:(ASIHTTPRequest *)request {
	[spinner stopAnimating];
	spinner.hidden = YES;
	NSString *errorAlertText;
	if ([request responseStatusCode] == 401) {
		errorAlertText = [NSString
						  stringWithString:@"Login problem: you were never logged in or have deauthorized this app. Please log in again."];
		[oAuth forget];
		[self saveOAuthTwitterContextToUserDefaults];
		[self resetUiState];
	} else {
		errorAlertText = [NSString
						  stringWithString:@"Some technical problem (fail whale on Twitter servers?). Try again, it should work again soon."];
	}
	UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorAlertText
														delegate:nil
											   cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
	[errorAlert release];
}

#pragma mark -
#pragma mark UI manipulation, login/logout button actions

- (void) resetUiState {
	[self loadOAuthTwitterContextFromUserDefaults];
	UIBarButtonItem *twitterAuthButton;
	
	if (oAuth.oauth_token_authorized) {
		twitterAuthButton = [[UIBarButtonItem alloc]
											  initWithTitle:@"Log out"
											  style:UIBarButtonItemStylePlain
											  target:self
											  action:@selector(logOut)];
		screenNameLabel.text = oAuth.screen_name;
	} else {
		twitterAuthButton = [[UIBarButtonItem alloc]
											  initWithTitle:@"Log in"
											  style:UIBarButtonItemStylePlain
											  target:self
											  action:@selector(showTwitterLoginPopup)];
		
		screenNameLabel.text = @"(none)";
		
	}
	self.navigationItem.rightBarButtonItem = twitterAuthButton;
	[twitterAuthButton release];
		
	if (oAuth.oauth_token_authorized) {
		if ([oAuth synchronousVerifyTwitterCredentials]) {
			NSLog(@"Credentials verified.");
		} else {
			NSLog(@"Credentials error, NOT verified. Should trigger re-login at this point.");
		}
	}
}

- (void) logOut {
	[oAuth forget];
	[self saveOAuthTwitterContextToUserDefaults];
	[self resetUiState];
}

- (void) showTwitterLoginPopup {
	
	TwitterLoginPopup *twitterLoginPopup = [[TwitterLoginPopup alloc] initWithNibName:@"TwitterLoginPopup" bundle:nil];
	UINavigationController *popupController = [[UINavigationController alloc] initWithRootViewController:twitterLoginPopup];
	twitterLoginPopup.delegate = self;
	[self presentModalViewController:popupController animated:YES];
}

#pragma mark -
#pragma mark TwitterLoginPopupDelegate callbacks

- (void) twitterLoginPopupDidCancel:(TwitterLoginPopup *)popup {
	[self dismissModalViewControllerAnimated:YES];
}

- (void) twitterLoginPopupDidAuthorize:(TwitterLoginPopup *)popup {
	[self dismissModalViewControllerAnimated:YES];
	[self resetUiState];
}

#pragma mark -
#pragma mark UIViewController, memory mgmt

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self resetUiState];
	
	if (!oAuth.oauth_token_authorized) {
		[self showTwitterLoginPopup];
	}
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[screenNameLabel release];
	[statusField release];
	[spinner release];
    [super dealloc];
}


@end
