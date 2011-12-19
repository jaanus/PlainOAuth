//
//  4sqController.h
//  PlainOAuth
//
//  Created by Jaanus Kase on 27.11.11.
//  Copyright (c) 2011 Intuit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthLoginPopupDelegate.h"

@class OAuth, FoursquareLoginPopup;

@interface FoursquareController : UIViewController <oAuthLoginPopupDelegate> {
    FoursquareLoginPopup *loginPopup;
}
@property (retain, nonatomic) IBOutlet UIButton *seeCheckinsButton;
@property (retain, nonatomic) IBOutlet UITextView *checkinsField;
- (IBAction)didTapSeeCheckins:(id)sender;

@property (retain, nonatomic) OAuth *oAuth4sq;

@end
