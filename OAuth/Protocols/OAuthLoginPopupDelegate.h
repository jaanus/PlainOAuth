/*
 *  TwitterLoginPopupDelegate.h
 *  Special People
 *
 *  Created by Jaanus Kase on 19.04.10.
 *  Copyright 2010. All rights reserved.
 *
 */

@protocol oAuthLoginPopupDelegate <NSObject>
- (void)oAuthLoginPopupDidCancel:(UIViewController *)popup;
- (void)oAuthLoginPopupDidAuthorize:(UIViewController *)popup;
@end