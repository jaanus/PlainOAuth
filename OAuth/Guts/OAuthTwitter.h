//
//  OAuthTwitter.h
//  PlainOAuth
//
//  Created by Jaanus Kase on 13.11.11.
//  Copyright (c) 2011 Intuit. All rights reserved.
//

#import "OAuth.h"

@interface OAuthTwitter : OAuth {

    NSString
    
    // From Twitter. May or may not be applicable to other providers.
    *user_id,
    *screen_name;
    
}

@property (copy) NSString *user_id;
@property (copy) NSString *screen_name;

// Twitter convenience methods
- (void) synchronousRequestTwitterToken;
- (void) synchronousRequestTwitterTokenWithCallbackUrl:(NSString *)callbackUrl;
- (void) synchronousAuthorizeTwitterTokenWithVerifier:(NSString *)oauth_verifier;
- (BOOL) synchronousVerifyTwitterCredentials;

@end
