//
//  PlainOAuthUnitTests.m
//  PlainOAuthUnitTests
//
//  Created by Jaanus Kase on 28.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlainOAuthUnitTests.h"
#import "OAuth.h"
#import "OAuthConsumerCredentials.h"

@implementation PlainOAuthUnitTests

- (void)setUp
{
    [super setUp];
    oAuth = [[OAuth alloc] initWithConsumerKey:OAUTH_CONSUMER_KEY andConsumerSecret:OAUTH_CONSUMER_SECRET];
}

- (void)tearDown
{
    [oAuth release];    
    [super tearDown];
}


- (void)testUtf8ParameterValue {
    NSString *header = [oAuth oAuthHeaderForMethod:@"GET"
                                            andUrl:@"http://www.example.com/"
                                         andParams:[NSDictionary dictionaryWithObjectsAndKeys:@"hõäöš€", @"utf8Value", nil]];
    
    NSRange range = [header rangeOfString:@"h%C3%B5%C3%A4%C3%B6%C5%A1%E2%82%AC"];
    if (range.location == NSNotFound) {
        STFail(@"Did not detect expected encoded UTF-8 parameter value in OAuth header");
    }
    
}

- (void)testUtf8KeyValue {
    NSString *header = [oAuth oAuthHeaderForMethod:@"GET"
                                            andUrl:@"http://www.example.com/"
                                         andParams:[NSDictionary dictionaryWithObjectsAndKeys:@"value", @"utf8Keyhõäöš€", nil]];

    NSRange range = [header rangeOfString:@"h%C3%B5%C3%A4%C3%B6%C5%A1%E2%82%AC"];
    if (range.location == NSNotFound) {
        STFail(@"Did not detect expected encoded UTF-8 key value in OAuth header");
    }


}

@end
