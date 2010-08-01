//
//  TwitterLoginPopup.h
//
//  Created by Jaanus Kase on 15.01.10.
//  Copyright 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthTwitterCallbacks.h"
#import "TwitterLoginPopupDelegate.h"
#import "TwitterLoginUiFeedback.h"

@class OAuth, TwitterWebViewController;

@interface TwitterLoginPopup : UIViewController <OAuthTwitterCallbacks,
    UINavigationControllerDelegate, UIWebViewDelegate> {
    IBOutlet UITextField *pinField;
    
    IBOutlet UIButton *getPinButton, *signInButton;
    
    IBOutlet UILabel *typePinBelow;
    IBOutlet UIImageView *signInBullet2;
    
	id <TwitterLoginPopupDelegate> delegate;
	id <TwitterLoginUiFeedback> uiDelegate;
	
	
	NSOperationQueue *queue;
	OAuth *oAuth;
	UIWebView *webView;
	TwitterWebViewController *webViewController;
	BOOL willBeEditingPin;
        
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *contentView;
}

- (IBAction)getPin:(id)sender;
- (IBAction)savePin:(id)sender;

- (void) focusPinField;
- (void) fixSignInButtonPositionWithOrientation:(UIDeviceOrientation)orientation andAnimationDuration:(NSTimeInterval)duration;
- (CGFloat) keyboardHeightFromNotification:(NSNotification *)aNotification;

@property (assign) id<TwitterLoginPopupDelegate> delegate;
@property (assign) id<TwitterLoginUiFeedback> uiDelegate;

@property (nonatomic, retain) OAuth *oAuth;

@end


