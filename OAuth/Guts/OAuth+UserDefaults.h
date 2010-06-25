//
//  OAuth+UserDefaults.h
//  SPTweetTable
//
//  Created by Jaanus Kase on 23.01.10.
//  Copyright 2010. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OAuth;

@interface OAuth (OAuth_UserDefaults)

- (void) loadOAuthTwitterContextFromUserDefaults;
- (void) loadOAuthContextFromUserDefaults;

- (void) saveOAuthContextToUserDefaults;
- (void) saveOAuthTwitterContextToUserDefaults;

- (void) saveOAuthContextToUserDefaults:(OAuth *)oAuthContext;
- (void) saveOAuthTwitterContextToUserDefaults:(OAuth *)oAuthContext;

@end
