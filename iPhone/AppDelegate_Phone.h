//
//  AppDelegate_Phone.h
//  Plain2
//
//  Created by Jaanus Kase on 03.05.10.
//  Copyright 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate_Phone : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UINavigationController *nav;
    RootViewController *root;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

