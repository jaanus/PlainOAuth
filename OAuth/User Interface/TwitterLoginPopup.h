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

typedef enum {
    TwitterLoginPinFlow,
    TwitterLoginCallbackFlow
} TwitterLoginFlowType;

@interface TwitterLoginPopup : UIViewController <OAuthTwitterCallbacks,
    UINavigationControllerDelegate, UIWebViewDelegate> {
    IBOutlet UITextField *pinField;
    
    IBOutlet UIButton *getPinButton, *signInButton;
    
    IBOutlet UILabel *typePinBelow;
    IBOutlet UIImageView *signInBullet2;
    
	id <TwitterLoginPopupDelegate> delegate;
	id <TwitterLoginUiFeedback> uiDelegate;
	
    TwitterLoginFlowType flowType;
	
	NSOperationQueue *queue;
	OAuth *oAuth;
	IBOutlet UIWebView *webView;
	TwitterWebViewController *webViewController;
	BOOL willBeEditingPin;
        
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *contentView;
        
    NSString *oAuthCallbackUrl;
}

@property (assign) id<TwitterLoginPopupDelegate> delegate;
@property (assign) id<TwitterLoginUiFeedback> uiDelegate;

@property (assign) TwitterLoginFlowType flowType;

@property (nonatomic, retain) OAuth *oAuth;
@property (nonatomic, copy) NSString *oAuthCallbackUrl;

// Call this when receiving the verifier as URL parameter in URL callback flow,
// or when input in the UI.
- (void)authorizeOAuthVerifier:(NSString *)oauth_verifier;

@end


