//
//  OAuthTwitter.m
//  PlainOAuth
//
//  Created by Jaanus Kase on 13.11.11.
//  Copyright (c) 2011 Intuit. All rights reserved.
//

#import "OAuthTwitter.h"

@implementation OAuthTwitter

@synthesize screen_name, user_id;
@synthesize delegate;

#pragma mark -
#pragma mark Init and dealloc

- (id) initWithConsumerKey:(NSString *)aConsumerKey andConsumerSecret:(NSString *)aConsumerSecret {
    if ((self = [super initWithConsumerKey:aConsumerKey andConsumerSecret:aConsumerSecret])) {
        self.user_id = @"";
		self.screen_name = @"";
        self.delegate = nil;
    }
    return self;
}

- (void) dealloc {
    [user_id release];
	[screen_name release];
    [super dealloc];
}

#pragma mark -
#pragma mark Twitter convenience methods

/**
 * Convenience method for PIN-based flow. Start a token request with out-of-band URL.
 */
- (void) synchronousRequestTwitterToken {
    
    // request_token step must have oauth_callback set to "oob" for PIN-based requests.
    // http://twitter.com/episod/status/20508312741, http://twitter.com/episod/status/20722145979
    
    [self synchronousRequestTwitterTokenWithCallbackUrl:@"oob"];
}

/**
 * Given a request URL, request an unauthorized OAuth token from that URL. This starts
 * the process of getting permission from user. This is done synchronously. If you want
 * threading, do your own.
 *
 * This is the request/response specified in OAuth Core 1.0A section 6.1.
 */
- (void) synchronousRequestTwitterTokenWithCallbackUrl:(NSString *)callbackUrl {
   	NSString *url = @"https://api.twitter.com/oauth/request_token";
	
	// Invalidate the previous request token, whether it was authorized or not.
	self.oauth_token_authorized = NO; // We are invalidating whatever token we had before.
	self.oauth_token = @"";
	self.oauth_token_secret = @"";
	
	// Calculate the header.
    
    // Guard against someone forgetting to set the callback. Pretend that we have out-of-band request
    // in that case.
    NSString *_callbackUrl = callbackUrl;
    if (!callbackUrl) {
        _callbackUrl = @"oob";
    }
    NSDictionary *params = [NSDictionary dictionaryWithObject:_callbackUrl forKey:@"oauth_callback"];
	NSString *oauth_header = [self oAuthHeaderForMethod:@"POST" andUrl:url andParams:params];
	
	// Synchronously perform the HTTP request.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10.0f]; 
	[request setHTTPMethod:@"POST"];
    [request addValue:oauth_header forHTTPHeaderField:@"Authorization"];
    
    NSHTTPURLResponse *response;
    NSError *error = nil;
    
    NSString *responseString = [[[NSString alloc] initWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error] encoding:NSUTF8StringEncoding] autorelease];    
	
	if ([response statusCode] != 200) {
		if ([self.delegate respondsToSelector:@selector(requestTwitterTokenDidFail:)]) {
			[delegate requestTwitterTokenDidFail:self];
		}
	} else {
		NSArray *responseBodyComponents = [responseString componentsSeparatedByString:@"&"];
		// For a successful response, break the response down into pieces and set the properties
		// with KVC. If there's a response for which there is no local property or ivar, this
		// may end up with setValue:forUndefinedKey:.
		for (NSString *component in responseBodyComponents) {
			NSArray *subComponents = [component componentsSeparatedByString:@"="];
			[self setValue:[subComponents objectAtIndex:1] forKey:[subComponents objectAtIndex:0]];			
		}
		if ([self.delegate respondsToSelector:@selector(requestTwitterTokenDidSucceed:)]) {
			[delegate requestTwitterTokenDidSucceed:self];
		}
	}
}


/**
 * By this point, we have a token, and we have a verifier such as PIN from the user. We combine
 * these together and exchange the unauthorized token for a new, authorized one.
 *
 * This is the request/response specified in OAuth Core 1.0A section 6.3.
 */
- (void) synchronousAuthorizeTwitterTokenWithVerifier:(NSString *)oauth_verifier {
	
	NSString *url = @"https://api.twitter.com/oauth/access_token";
	
	// We manually specify the token as a param, because it has not yet been authorized
	// and the automatic state checking wouldn't include it in signature construction or header,
	// since oauth_token_authorized is still NO by this point.
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
							oauth_token, @"oauth_token",
							oauth_verifier, @"oauth_verifier",
							nil];
	
	NSString *oauth_header = [super oAuthHeaderForMethod:@"POST" andUrl:url andParams:params andTokenSecret:oauth_token_secret];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10.0f]; 
	[request setHTTPMethod:@"POST"];
    [request addValue:oauth_header forHTTPHeaderField:@"Authorization"];
    
    NSHTTPURLResponse *response;
    NSError *error = nil;
    
    NSString *responseString = [[[NSString alloc] initWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error] encoding:NSUTF8StringEncoding] autorelease];    
	
	if ([response statusCode] != 200) {
        
        NSLog(@"HTTP return code for token authorization error: %d, message: %@, string: %@", [response statusCode], [NSHTTPURLResponse localizedStringForStatusCode:[response statusCode]], responseString);
        NSLog(@"OAuth header was: %@", oauth_header);
        
		if ([self.delegate respondsToSelector:@selector(authorizeTwitterTokenDidFail:)]) {
			[delegate authorizeTwitterTokenDidFail:self];
		}
	} else {
		NSArray *responseBodyComponents = [responseString componentsSeparatedByString:@"&"];
		for (NSString *component in responseBodyComponents) {
			// Twitter as of January 2010 returns oauth_token, oauth_token_secret, user_id and screen_name.
			// We support all these.
			NSArray *subComponents = [component componentsSeparatedByString:@"="];
			[self setValue:[subComponents objectAtIndex:1] forKey:[subComponents objectAtIndex:0]];			
		}
		
		self.oauth_token_authorized = YES;
		if ([self.delegate respondsToSelector:@selector(authorizeTwitterTokenDidSucceed:)]) {
			[delegate authorizeTwitterTokenDidSucceed:self];
		}
	}
}


/**
 * Verify with the provider whether the credentials are currently valid. YES if yes.
 */
- (BOOL) synchronousVerifyTwitterCredentials {
	
	NSString *url = @"https://api.twitter.com/1/account/verify_credentials.json";
	
	NSString *oauth_header = [self oAuthHeaderForMethod:@"GET" andUrl:url andParams:nil];
	
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10.0f]; 
	[request setHTTPMethod:@"GET"];
    [request addValue:oauth_header forHTTPHeaderField:@"Authorization"];
    
    NSHTTPURLResponse *response;
    NSError *error = nil;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];    
    
	if ([response statusCode] != 200) {
		return NO;
	} else {
		return YES;
	}
}

#pragma mark -
#pragma mark State management, loading, saving

- (void) forget {
    self.user_id = @"";
	self.screen_name = @"";
    [super forget];
}

- (void) load {
    [super load];
    self.user_id = [[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"%@user_id", self.save_prefix]];
	self.screen_name = [[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"%@screen_name", self.save_prefix]];
}

- (void) save {
    [super save];
    [[NSUserDefaults standardUserDefaults] setObject:self.user_id forKey:[NSString stringWithFormat:@"%@user_id", self.save_prefix]];
	[[NSUserDefaults standardUserDefaults] setObject:self.screen_name forKey:[NSString stringWithFormat:@"%@screen_name", self.save_prefix]];
}

@end
