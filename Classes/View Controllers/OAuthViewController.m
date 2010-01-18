//
//  OAuthViewController.m
//
//  Created by Jaanus Kase on 16.01.10.
//  Copyright 2010. All rights reserved.
//

#import "OAuthViewController.h"
#import "OAuthConsumerCredentials.h"

@implementation OAuthViewController

 // The designated initializer.  Override if you create the controller programmatically and
 // want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		oAuth = [[OAuth alloc] initWithConsumerKey:OAUTH_CONSUMER_KEY andConsumerSecret:OAUTH_CONSUMER_SECRET];
    }
    return self;
}

// The following tasks should really be done using keychain in a real app. But we will use userDefaults
// for the sake of clarity and brevity of this example app. Do think about security for your own real use.
- (void) loadOAuthTwitterContextFromUserDefaults {
	[self loadOAuthContextFromUserDefaults];
	oAuth.user_id = [[NSUserDefaults standardUserDefaults] stringForKey:@"user_id"];
	oAuth.screen_name = [[NSUserDefaults standardUserDefaults] stringForKey:@"screen_name"];
}

- (void) loadOAuthContextFromUserDefaults {
	oAuth.oauth_token = [[NSUserDefaults standardUserDefaults] stringForKey:@"oauth_token"];
	oAuth.oauth_token_secret = [[NSUserDefaults standardUserDefaults] stringForKey:@"oauth_token_secret"];
	oAuth.oauth_token_authorized = [[NSUserDefaults standardUserDefaults] integerForKey:@"oauth_token_authorized"];
}

- (void) saveOAuthContextToUserDefaults {
	[self saveOAuthContextToUserDefaults:oAuth];
}

- (void) saveOAuthTwitterContextToUserDefaults {
	[self saveOAuthTwitterContextToUserDefaults:oAuth];
}

- (void) saveOAuthTwitterContextToUserDefaults:(OAuth *)_oAuth {
	[self saveOAuthContextToUserDefaults:_oAuth];
	[[NSUserDefaults standardUserDefaults] setObject:_oAuth.user_id forKey:@"user_id"];
	[[NSUserDefaults standardUserDefaults] setObject:_oAuth.screen_name forKey:@"screen_name"];
}

- (void) saveOAuthContextToUserDefaults:(OAuth *)_oAuth {
	[[NSUserDefaults standardUserDefaults] setObject:_oAuth.oauth_token forKey:@"oauth_token"];
	[[NSUserDefaults standardUserDefaults] setObject:_oAuth.oauth_token_secret forKey:@"oauth_token_secret"];
	[[NSUserDefaults standardUserDefaults] setInteger:_oAuth.oauth_token_authorized forKey:@"oauth_token_authorized"];
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
	[oAuth release];
    [super dealloc];
}


@end
