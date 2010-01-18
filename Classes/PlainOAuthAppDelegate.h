//
//  PlainOAuthAppDelegate.h
//  PlainOAuth
//
//  Created by Jaanus Kase on 17.01.10.
//  Copyright 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuth.h"
#import "RootViewController.h"

@interface PlainOAuthAppDelegate : NSObject <UIApplicationDelegate> {
	UINavigationController *rootNavController;
	RootViewController *rootViewController;
    UIWindow *window;	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *rootNavController;

@end

