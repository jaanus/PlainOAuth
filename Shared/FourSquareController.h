//
//  4sqController.h
//  PlainOAuth
//
//  Created by Jaanus Kase on 27.11.11.
//  Copyright (c) 2011 Intuit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthLoginPopupDelegate.h"

@class OAuth4sq, FoursquareLoginPopup;

@interface FoursquareController : UIViewController <oAuthLoginPopupDelegate> {
    FoursquareLoginPopup *loginPopup;
}

@property (retain, nonatomic) OAuth4sq *oAuth4sq;

@end
