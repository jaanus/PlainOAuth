//
//  UploadMedia.h
//  PlainOAuth
//
//  Created by Jaanus Kase on 03.07.10.
//  Copyright 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OAuth;

@interface UploadMedia : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    IBOutlet UIImageView *imageView;
    IBOutlet UIButton *postButton, *pickButton, *postProfileImageButton;
    IBOutlet UITextView *textView;
    IBOutlet UILabel *profileLabel, *twitpicLabel;
    UIPopoverController *popover;
    OAuth *oAuth;
}

@property (nonatomic, retain) OAuth *oAuth;

-(IBAction)didPressPickImage:(id)sender;
-(IBAction)didPressPostImage:(id)sender;
-(IBAction)didPressPostProfileImage:(id)sender;

@end
