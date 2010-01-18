//
//  RootViewController.h
//
//  Created by Jaanus Kase on 16.01.10.
//  Copyright 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "OAuth.h"
#import "OAuthViewController.h"
#import "TwitterLoginPopup.h"

@interface RootViewController : OAuthViewController <TwitterLoginPopupDelegate> {
    IBOutlet UILabel *screenNameLabel;
	IBOutlet UITextField *statusField;
	IBOutlet UIActivityIndicatorView *spinner;
}

- (IBAction)postStatus:(id)sender;
- (void) showTwitterLoginPopup;
- (void) resetUiState;

@end
