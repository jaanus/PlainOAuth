//
//  UploadMedia.h
//  PlainOAuth
//
//  Created by Jaanus Kase on 03.07.10.
//  Copyright 2010 Intuit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OAuth;

@interface UploadMedia : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    IBOutlet UIImageView *imageView;
    IBOutlet UIButton *postButton, *pickButton;
    IBOutlet UITextView *textView;
    UIPopoverController *popover;
    OAuth *oAuth;
}

@property (nonatomic, retain) OAuth *oAuth;

-(IBAction)didPressPickImage:(id)sender;
-(IBAction)didPressPostImage:(id)sender;

@end
