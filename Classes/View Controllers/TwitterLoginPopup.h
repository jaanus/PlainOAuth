//
//  TwitterLoginPopup.h
//
//  Created by Jaanus Kase on 15.01.10.
//  Copyright 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuth.h"
#import "OAuthViewController.h"

@protocol TwitterLoginPopupDelegate;

@interface TwitterLoginPopup : OAuthViewController <OAuthTwitterCallbacks> {
    IBOutlet UITextField *pinField;
    IBOutlet UIActivityIndicatorView *spinner;
	id <TwitterLoginPopupDelegate> delegate;
	NSOperationQueue *queue;
}

- (IBAction)getPin:(id)sender;
- (IBAction)savePin:(id)sender;

@property (assign) id<TwitterLoginPopupDelegate> delegate;

@end

@protocol TwitterLoginPopupDelegate
- (void)twitterLoginPopupDidCancel:(TwitterLoginPopup *)popup;
- (void)twitterLoginPopupDidAuthorize:(TwitterLoginPopup *)popup;
@end
