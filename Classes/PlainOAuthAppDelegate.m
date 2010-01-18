//
//  PlainOAuthAppDelegate.m
//  PlainOAuth
//
//  Created by Jaanus Kase on 12.01.10.
//  Copyright 2010. All rights reserved.
//

#import "PlainOAuthAppDelegate.h"

@implementation PlainOAuthAppDelegate

@synthesize window;
@synthesize rootNavController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	
    // Override point for customization after application launch
    [window makeKeyAndVisible];
	[window addSubview:[rootNavController view]];
	
	rootViewController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
	rootNavController.viewControllers = [NSArray arrayWithObject:rootViewController];
	
	// http://code.google.com/p/oauthconsumer/
	// http://github.com/jdg/oauthconsumer
	
}

- (void)dealloc {
	[rootViewController release];
	[rootNavController release];
    [window release];
    [super dealloc];
}

@end
