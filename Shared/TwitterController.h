//
//  RootViewController.h
//  Plain2
//
//  Created by Jaanus Kase on 03.05.10.
//  Copyright 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthLoginPopupDelegate.h"
#import "TwitterLoginUiFeedback.h"
#import "UploadMedia.h"

@class OAuthTwitter, CustomLoginPopup;

@interface TwitterController : UIViewController <oAuthLoginPopupDelegate, TwitterLoginUiFeedback, UIActionSheetDelegate> {
    IBOutlet UIButton *postButton, *latestTweetsButton, *uploadMediaButton;
    IBOutlet UITextField *statusText;
    IBOutlet UILabel *signedInAs;
    IBOutlet UITextView *tweets;
    IBOutlet UISwitch *includeLocation;
        
    CustomLoginPopup *loginPopup;
	
	OAuthTwitter *oAuthTwitter;
	
}

@property (retain, nonatomic) OAuthTwitter *oAuthTwitter;

- (IBAction)didPressPost:(id)sender;
- (IBAction)didPressLatestTweets:(id)sender;
- (IBAction)didPressUploadMedia:(id)sender;

- (void)handleOAuthVerifier:(NSString *)oauth_verifier;


@end
