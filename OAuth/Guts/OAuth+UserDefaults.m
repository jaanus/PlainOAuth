//
//  OAuth+UserDefaults.m
//  SPTweetTable
//
//  Created by Jaanus Kase on 23.01.10.
//  Copyright 2010. All rights reserved.
//

#import "OAuth.h"
#import "OAuth+UserDefaults.h"


@implementation OAuth (OAuth_UserDefaults)

// The following tasks should really be done using keychain in a real app. But we will use userDefaults
// for the sake of clarity and brevity of this example app. Do think about security for your own real use.
- (void) loadOAuthTwitterContextFromUserDefaults {
	[self loadOAuthContextFromUserDefaults];
	self.user_id = [[NSUserDefaults standardUserDefaults] stringForKey:@"user_id"];
	self.screen_name = [[NSUserDefaults standardUserDefaults] stringForKey:@"screen_name"];
}

- (void) loadOAuthContextFromUserDefaults {
	self.oauth_token = [[NSUserDefaults standardUserDefaults] stringForKey:@"oauth_token"];
	self.oauth_token_secret = [[NSUserDefaults standardUserDefaults] stringForKey:@"oauth_token_secret"];
	self.oauth_token_authorized = [[NSUserDefaults standardUserDefaults] integerForKey:@"oauth_token_authorized"];
}

- (void) saveOAuthContextToUserDefaults {
	[self saveOAuthContextToUserDefaults:self];
}

- (void) saveOAuthTwitterContextToUserDefaults {
	[self saveOAuthTwitterContextToUserDefaults:self];
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

@end
