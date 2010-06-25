//
//  AppDelegate_Pad.m
//  Plain2
//
//  Created by Jaanus Kase on 03.05.10.
//  Copyright 2010. All rights reserved.
//

#import "AppDelegate_Pad.h"
#import "RootViewController.h"


@implementation AppDelegate_Pad

@synthesize window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
    // Override point for customization after application launch
	
    [window makeKeyAndVisible];
    
    RootViewController *root = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
	nav = [[UINavigationController alloc] initWithRootViewController:root];
	[window addSubview:nav.view];
	[root release];
    
	
	return YES;
}


- (void)dealloc {
    [nav release];
    [window release];
    [super dealloc];
}


@end
