//
//  OAuthTwitter.h
//  PlainOAuth
//
//  Created by Jaanus Kase on 13.11.11.
//  Copyright (c) 2011 Intuit. All rights reserved.
//

#import "OAuth.h"
#import "OAuthTwitterCallbacks.h"

@interface OAuthTwitter : OAuth {

    NSString
    
    // From Twitter. May or may not be applicable to other providers.
    *user_id,
    *screen_name;
    
    id<OAuthTwitterCallbacks> delegate;
}

@property (copy) NSString *user_id;
@property (copy) NSString *screen_name;
@property (assign) id<OAuthTwitterCallbacks> delegate;

// Twitter convenience methods
- (void) synchronousRequestTwitterToken;
- (void) synchronousRequestTwitterTokenWithCallbackUrl:(NSString *)callbackUrl;
- (void) synchronousAuthorizeTwitterTokenWithVerifier:(NSString *)oauth_verifier;
- (BOOL) synchronousVerifyTwitterCredentials;

@end
