//
//  Master.h
//  PlainOAuth
//
//  Created by Jaanus Kase on 27.11.11.
//  Copyright (c) 2011 Intuit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OAuthTwitter, TwitterController;

@interface Master : UIViewController <UINavigationControllerDelegate> {
    OAuthTwitter *oAuthTwitter;
    TwitterController *twitterController;
}

- (IBAction)didTapTwitter:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *twitterAuthStatus;

- (void) resetUi;
- (void) handleOAuthVerifier:(NSString *)oauth_verifier;

@end
