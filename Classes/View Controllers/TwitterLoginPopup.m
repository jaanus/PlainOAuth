//
//  TwitterLoginPopup.m
//
//  Created by Jaanus Kase on 15.01.10.
//  Copyright 2010. All rights reserved.
//

#import "TwitterLoginPopup.h"
#import "OAuthConsumerCredentials.h"

@implementation TwitterLoginPopup

@synthesize delegate;

#pragma mark Button actions

- (IBAction)getPin:(id)sender {
    spinner.hidden = NO;
	[spinner startAnimating];
	
	NSInvocationOperation *operation = [[NSInvocationOperation alloc]
										initWithTarget:oAuth
										selector:@selector(synchronousRequestTwitterToken)
										object:nil];
	
	[queue addOperation:operation];
	[operation release];
}

- (IBAction)savePin:(id)sender {
    [pinField resignFirstResponder];
	spinner.hidden = NO;
	[spinner startAnimating];

	NSInvocationOperation *operation = [[NSInvocationOperation alloc]
										initWithTarget:oAuth
										selector:@selector(synchronousAuthorizeTwitterTokenWithVerifier:)
										object:pinField.text];
	[queue addOperation:operation];
	[operation release];
	
}

- (void)cancel {
	[self.delegate twitterLoginPopupDidCancel:self];
}

#pragma mark -
#pragma mark OAuthTwitterCallbacks protocol


// For all of these methods, we invoked oAuth in a background thread, so these are also called
// in background thread. So we first transfer the control back to main thread before doing
// anything else.

- (void) requestTwitterTokenDidSucceed:(OAuth *)_oAuth {
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(requestTwitterTokenDidSucceed:)
							   withObject:_oAuth
							waitUntilDone:NO];
		return;
	}
	[self saveOAuthTwitterContextToUserDefaults:_oAuth];
	NSURL *myURL = [NSURL URLWithString:[NSString
										 stringWithFormat:@"https://twitter.com/oauth/authorize?oauth_token=%@",
										 _oAuth.oauth_token]];
	[[UIApplication sharedApplication] openURL:myURL];
	
}

- (void) requestTwitterTokenDidFail:(OAuth *)_oAuth {
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(requestTwitterTokenDidFail:)
							   withObject:_oAuth
							waitUntilDone:NO];
		return;
	}
	[spinner stopAnimating];
	spinner.hidden = YES;
	
	UIAlertView *tokenFail = [[UIAlertView alloc]
							  initWithTitle:@"Technical problem"
							  message:@"There was a technical problem talking to Twitter. Try again."
							  delegate:nil
							  cancelButtonTitle:@"OK"
							  otherButtonTitles:nil];
	[tokenFail show];
	[tokenFail release];
}

- (void) authorizeTwitterTokenDidSucceed:(OAuth *)_oAuth {
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(authorizeTwitterTokenDidSucceed:)
							   withObject:_oAuth
							waitUntilDone:NO];
		return;
	}
	[self saveOAuthTwitterContextToUserDefaults:_oAuth];
	[spinner stopAnimating];
	spinner.hidden = YES;
	[self.delegate twitterLoginPopupDidAuthorize:self];
}

- (void) authorizeTwitterTokenDidFail:(OAuth *)_oAuth {
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(authorizeTwitterTokenDidFail:)
							   withObject:_oAuth
							waitUntilDone:NO];
		return;
	}
	[spinner stopAnimating];
	spinner.hidden = YES;
	
	UIAlertView *tokenFail = [[UIAlertView alloc]
							  initWithTitle:@"Invalid PIN or technical problem"
							  message:@"Either the PIN is wrong, or there was a technical problem talking to Twitter. Try again."
							  delegate:nil
							  cancelButtonTitle:@"OK"
							  otherButtonTitles:nil];
	[tokenFail show];
	[tokenFail release];
}

#pragma mark -
#pragma mark UIViewController and memory mgmt

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Connect to Twitter";
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
										  initWithTitle:@"Cancel"
										  style:UIBarButtonItemStylePlain
										  target:self
										  action:@selector(cancel)];	
	// rootNavController.navigationItem
	self.navigationItem.rightBarButtonItem = cancelButton;
	[cancelButton release];
	queue = [[NSOperationQueue alloc] init];
	[self loadOAuthContextFromUserDefaults];
	
	oAuth.delegate = self;

}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	[queue release];
}

- (void)dealloc {
	[oAuth release];
	[pinField release];
	[spinner release];
    [super dealloc];
}

#pragma mark -
#pragma mark Keyboard notifications from Apple's UICatalog example

/**
 * The code comes straight from Apple's UICatalog example, except that I have modified the UI manipulation
 * to use bounds instead of frame, so that when keyboard is shown, the view "scrolls" to the right place
 * so that the input field would remain visible.
 */

- (void)viewWillAppear:(BOOL)animated 
{
    // listen for keyboard hide/show notifications so we can properly adjust the table's height
	[super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
												 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated 
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)aNotification {
	// the keyboard is showing so resize the my height
	CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	
	CGRect bounds = self.view.bounds;
	bounds.origin.y += keyboardRect.size.height;
	
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
	self.view.bounds = bounds;
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    // the keyboard is hiding reset the table's height
	CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	CGRect bounds = self.view.bounds;
	bounds.origin.y -= keyboardRect.size.height;
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.bounds = bounds;
    [UIView commitAnimations];
}

@end
