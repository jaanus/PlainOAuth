//
//  AppDelegate_Pad.m
//  Plain2
//
//  Created by Jaanus Kase on 03.05.10.
//  Copyright 2010. All rights reserved.
//

#import "AppDelegate_Pad.h"
#import "Master.h"


@implementation AppDelegate_Pad

@synthesize window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
    // Override point for customization after application launch
	
    [window makeKeyAndVisible];
    
    root = [[Master alloc] initWithNibName:@"Master" bundle:nil];
	nav = [[UINavigationController alloc] initWithRootViewController:root];
    nav.delegate = root;
	[window addSubview:nav.view];
    
	
	return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    // naively parse url
    NSArray *urlComponents = [[url absoluteString] componentsSeparatedByString:@"?"];
    NSArray *requestParameterChunks = [[urlComponents objectAtIndex:1] componentsSeparatedByString:@"&"];
    for (NSString *chunk in requestParameterChunks) {
        NSArray *keyVal = [chunk componentsSeparatedByString:@"="];
        
        if ([[keyVal objectAtIndex:0] isEqualToString:@"oauth_verifier"]) {
            [root handleOAuthVerifier:[keyVal objectAtIndex:1]];
        }
        
    }
    
    return YES;
}


- (void)dealloc {
	[root release];
    [nav release];
    [window release];
    [super dealloc];
}


@end
