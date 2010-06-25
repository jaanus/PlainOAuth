//
//  CustomLoginPopup.h
//  Plain2
//
//  Created by Jaanus Kase on 03.05.10.
//  Copyright 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterLoginPopup.h"

@interface CustomLoginPopup : TwitterLoginPopup {
    UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, readonly, retain) UIActivityIndicatorView *activityIndicator;

@end
