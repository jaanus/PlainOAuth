//
//  OAuthViewController.h
//
//  Created by Jaanus Kase on 16.01.10.
//  Copyright 2010. All rights reserved.
//
//  A simple OAuth-enabled view controller that maintains the local OAuth context.

#import <UIKit/UIKit.h>
#import "OAuth.h"

@interface OAuthViewController : UIViewController {
	OAuth *oAuth;
}

- (void) loadOAuthTwitterContextFromUserDefaults;
- (void) loadOAuthContextFromUserDefaults;

- (void) saveOAuthContextToUserDefaults;
- (void) saveOAuthTwitterContextToUserDefaults;

- (void) saveOAuthContextToUserDefaults:(OAuth *)oAuthContext;
- (void) saveOAuthTwitterContextToUserDefaults:(OAuth *)oAuthContext;

@end
