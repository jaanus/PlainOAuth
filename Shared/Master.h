//
//  Master.h
//  PlainOAuth
//
//  Created by Jaanus Kase on 27.11.11.
//  Copyright (c) 2011 Intuit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OAuthTwitter, OAuth, TwitterController, FoursquareController;

@interface Master : UIViewController <UINavigationControllerDelegate> {
    OAuthTwitter *oAuthTwitter;
    OAuth *oAuth4sq;
    TwitterController *twitterController;
    FoursquareController *foursquareController;
}

- (IBAction)didTapTwitter:(id)sender;
- (IBAction)didTapFoursquare:(id)sender;

@property (retain, nonatomic) IBOutlet UILabel *twitterAuthStatus;
@property (retain, nonatomic) IBOutlet UILabel *foursquareAuthStatus;

- (void) resetUi;
- (void) handleOAuthVerifier:(NSString *)oauth_verifier;

@end
