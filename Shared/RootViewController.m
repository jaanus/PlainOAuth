//
//  RootViewController.m
//  Plain2
//
//  Created by Jaanus Kase on 03.05.10.
//  Copyright 2010. All rights reserved.
//

#import "RootViewController.h"
#import "OAuth.h"
#import "OAuth+UserDefaults.h"
#import "OAuthConsumerCredentials.h"
#import "CustomLoginPopup.h"
#import "TwitterLoginPopup.h"
#import "JSON.h"
#import "ASIFormDataRequest.h"

@interface RootViewController (PrivateMethods)

- (void)resetUi;
- (void)presentLoginWithFlowType:(TwitterLoginFlowType)flowType;

@end


@implementation RootViewController


/*
 // The designated initializer.  Override if you create the controller programmatically and
 // want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	self.title = @"Hello OAuth-Twitter";

	oAuth = [[OAuth alloc] initWithConsumerKey:OAUTH_CONSUMER_KEY andConsumerSecret:OAUTH_CONSUMER_SECRET];
	[oAuth loadOAuthTwitterContextFromUserDefaults];
	    
    [self resetUi];
    [tweets setFont:[UIFont systemFontOfSize:12]];
    
}

- (void)resetUi {
    if (oAuth.oauth_token_authorized) {
        tweets.hidden = NO;
        uploadMediaButton.hidden = NO;
        tweets.text = @"";
        latestTweetsButton.hidden = NO;
        signedInAs.text = [NSString stringWithFormat:@"Logged in as %@.", oAuth.screen_name];
        NSLog(@"Resetting UI to authorized state. Twitter user: %@", oAuth.screen_name);
        postButton.enabled = YES;
        statusText.enabled = YES;
        includeLocation.enabled = YES;
        
        UIBarButtonItem *logout = [[UIBarButtonItem alloc] initWithTitle:@"Log out"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(logout)];
        self.navigationItem.rightBarButtonItem = logout;
        [logout release];
        
    } else {
        tweets.text = @"";
        tweets.hidden = YES;
        latestTweetsButton.hidden = YES;
        uploadMediaButton.hidden = YES;
        tweets.text = @"";
        signedInAs.text = @"";
        NSLog(@"Resetting UI to non-authorized state.");
        
        postButton.enabled = NO;
        statusText.text = @"";
        statusText.enabled = NO;
        includeLocation.enabled = NO;
        
        UIBarButtonItem *login = [[UIBarButtonItem alloc] initWithTitle:@"Log in"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(login)];
        self.navigationItem.rightBarButtonItem = login;
        [login release];
        
    }
    
    [statusText resignFirstResponder];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {	
    
    // Supports all but upside-down orientation.
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    
    [oAuth release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Button actions

- (void)login {
    
    UIActionSheet *pickFlow = [[UIActionSheet alloc] initWithTitle:@"Select login flow" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"PIN", @"URL callback", nil];
    [pickFlow showInView:self.view];
    [pickFlow release];
    
    

}

- (void)logout {
    [oAuth forget];
    [oAuth saveOAuthTwitterContextToUserDefaults];
    [self resetUi];
}

- (IBAction)didPressPost:(id)sender {
    
    // We assume that the user is authenticated by this point and we have a valid OAuth context,
    // thus no need to do context checking.
    
    NSString *postUrl = @"https://api.twitter.com/1/statuses/update.json";
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc]
                                   initWithURL:[NSURL URLWithString:postUrl]];
    
    NSMutableDictionary *postInfo = [NSMutableDictionary
                                     dictionaryWithObject:statusText.text
                                     forKey:@"status"];
    
    if (includeLocation.on) {        
        // Hardcoded to Cupertino, CA for testing, same coordinates as in Apple/Twitter examples.
        [postInfo setObject:@"37.33182" forKey:@"lat"];
        [postInfo setObject:@"-122.03118" forKey:@"long"];
    }
    
    for (NSString *key in [postInfo allKeys]) {
        [request setPostValue:[postInfo objectForKey:key] forKey:key];
    }
    
    [request addRequestHeader:@"Authorization"
                        value:[oAuth oAuthHeaderForMethod:@"POST"
                                                   andUrl:postUrl
                                                andParams:postInfo]];
    
    [request startSynchronous];
    
    NSLog(@"Status posted. HTTP result code: %d", request.responseStatusCode);
    
    statusText.text = @"";
    
    [request release];
    
    [statusText resignFirstResponder];
}

- (IBAction)didPressLatestTweets:(id)sender {
    NSString *getUrl = @"http://api.twitter.com/1/statuses/user_timeline.json";
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"5", @"count", nil];
    
    // Note how the URL is without parameters here...
    // (this is how OAuth works, you always give it a "normalized" URL without parameters
    // since you give parameters separately to it, even for GET)
    NSString *oAuthValue = [oAuth oAuthHeaderForMethod:@"GET" andUrl:getUrl andParams:params];
    
    // ... but the actual request URL contains normal GET parameters.
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc]
                               initWithURL:[NSURL URLWithString:[NSString
                                                                 stringWithFormat:@"%@?count=%@",
                                                                 getUrl,
                                                                 [params valueForKey:@"count"]]]];
    [request addRequestHeader:@"Authorization" value:oAuthValue];
    [request startSynchronous];
    
    NSLog(@"Got statuses. HTTP result code: %d", request.responseStatusCode);
    
    tweets.text = @"";
    
    NSArray *gotTweets = [[request responseString] JSONValue];
    
    for (NSDictionary *tweet in gotTweets) {
        tweets.text = [NSString stringWithFormat:@"%@%@\n", tweets.text, [tweet valueForKey:@"text"]];
    } 
    
    [request release];
    
    [statusText resignFirstResponder];
}

- (IBAction)didPressUploadMedia:(id)sender {
    UploadMedia *uploadMedia = [[UploadMedia alloc] initWithNibName:@"UploadMedia" bundle:nil];
    uploadMedia.oAuth = oAuth;
    [self.navigationController pushViewController:uploadMedia animated:YES];
    [uploadMedia release];
}


#pragma mark -
#pragma mark TwitterLoginPopupDelegate

- (void)twitterLoginPopupDidCancel:(TwitterLoginPopup *)popup {
    [self dismissModalViewControllerAnimated:YES];        
    [loginPopup release]; loginPopup = nil; // was retained as ivar in "login"
}

- (void)twitterLoginPopupDidAuthorize:(TwitterLoginPopup *)popup {
    [self dismissModalViewControllerAnimated:YES];        
    [loginPopup release]; loginPopup = nil; // was retained as ivar in "login"
    [oAuth saveOAuthTwitterContextToUserDefaults];
    [self resetUi];
}

#pragma mark -
#pragma mark TwitterLoginUiFeedback

- (void) tokenRequestDidStart:(TwitterLoginPopup *)twitterLogin {
    NSLog(@"token request did start");
    [loginPopup.activityIndicator startAnimating];
}

- (void) tokenRequestDidSucceed:(TwitterLoginPopup *)twitterLogin {
    NSLog(@"token request did succeed");    
    [loginPopup.activityIndicator stopAnimating];
}

- (void) tokenRequestDidFail:(TwitterLoginPopup *)twitterLogin {
    NSLog(@"token request did fail");
    [loginPopup.activityIndicator stopAnimating];
}

- (void) authorizationRequestDidStart:(TwitterLoginPopup *)twitterLogin {
    NSLog(@"authorization request did start");    
    [loginPopup.activityIndicator startAnimating];
}

- (void) authorizationRequestDidSucceed:(TwitterLoginPopup *)twitterLogin {
    NSLog(@"authorization request did succeed");
    [loginPopup.activityIndicator stopAnimating];
}

- (void) authorizationRequestDidFail:(TwitterLoginPopup *)twitterLogin {
    NSLog(@"authorization token request did fail");
    [loginPopup.activityIndicator stopAnimating];
}


#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { // PIN-based
        [self presentLoginWithFlowType:TwitterLoginPinFlow];
    } else if (buttonIndex == 1) { // URL-based
        [self presentLoginWithFlowType:TwitterLoginCallbackFlow];
    }
}

#pragma mark -
#pragma mark Present login flows

- (void) presentLoginWithFlowType:(TwitterLoginFlowType)flowType {
        
    if (!loginPopup) {
        
        if (flowType == TwitterLoginPinFlow) {
            loginPopup = [[CustomLoginPopup alloc] initWithNibName:@"TwitterLoginPopup" bundle:nil];
        } else if (flowType == TwitterLoginCallbackFlow) {
            loginPopup = [[CustomLoginPopup alloc] initWithNibName:@"TwitterLoginCallbackFlow" bundle:nil];
            loginPopup.oAuthCallbackUrl = @"plainoauth://handleOAuthLogin";
        }
        
        loginPopup.flowType = flowType;
        loginPopup.oAuth = oAuth;
        loginPopup.delegate = self;
        loginPopup.uiDelegate = self;
    }
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginPopup];
    [self presentModalViewController:nav animated:YES];        
    [nav release];
}

- (void)handleOAuthVerifier:(NSString *)oauth_verifier {
    [loginPopup authorizeOAuthVerifier:oauth_verifier];
}


@end
