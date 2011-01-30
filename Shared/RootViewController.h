//
//  RootViewController.h
//  Plain2
//
//  Created by Jaanus Kase on 03.05.10.
//  Copyright 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterLoginPopupDelegate.h"
#import "TwitterLoginUiFeedback.h"
#import "UploadMedia.h"

@class OAuth, CustomLoginPopup;

@interface RootViewController : UIViewController <TwitterLoginPopupDelegate, TwitterLoginUiFeedback, UIActionSheetDelegate> {
    IBOutlet UIButton *postButton, *latestTweetsButton, *uploadMediaButton;
    IBOutlet UITextField *statusText;
    IBOutlet UILabel *signedInAs;
    IBOutlet UITextView *tweets;
    IBOutlet UISwitch *includeLocation;
        
    CustomLoginPopup *loginPopup;
	
	OAuth *oAuth;
	
}
- (IBAction)didPressPost:(id)sender;
- (IBAction)didPressLatestTweets:(id)sender;
- (IBAction)didPressUploadMedia:(id)sender;

- (void)handleOAuthVerifier:(NSString *)oauth_verifier;


@end
