//
//  UploadMedia.m
//  PlainOAuth
//
//  Created by Jaanus Kase on 03.07.10.
//  Copyright 2010. All rights reserved.
//

#import "UploadMedia.h"
#import "OAuth.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "OAuthConsumerCredentials.h"

@implementation UploadMedia

@synthesize oAuth;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Upload media demo";
    
    
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [popover release];
    [oAuth release];
    [super dealloc];
}

#pragma mark -
#pragma mark Button actions

-(IBAction)didPressPickImage:(id)sender {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePicker.allowsEditing = YES;
    imagePicker.mediaTypes = [NSArray arrayWithObject:@"public.image"];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        if (!popover) {
            popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];            
        }
        [popover presentPopoverFromRect:pickButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    } else {
        [self presentModalViewController:imagePicker animated:YES];        
    }
    
    [imagePicker release];
    
}

-(IBAction)didPressPostImage:(id)sender {
    
    ASIFormDataRequest *req = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.twitpic.com/2/upload.json"]];
    
    [req addRequestHeader:@"X-Auth-Service-Provider" value:@"https://api.twitter.com/1/account/verify_credentials.json"];
    [req addRequestHeader:@"X-Verify-Credentials-Authorization"
                    value:[oAuth oAuthHeaderForMethod:@"GET"
                                               andUrl:@"https://api.twitter.com/1/account/verify_credentials.json"
                                            andParams:nil]];    
    
    [req setData:UIImageJPEGRepresentation(imageView.image, 0.8) forKey:@"media"];
    
    // Define this somewhere or replace with your own key inline right here.
    [req setPostValue:TWITPIC_API_KEY forKey:@"key"];
    
    // TwitPic API doc says that message is mandatory, but looks like
    // it's actually optional in practice as of July 2010. You may or may not send it, both work.
    // [req setPostValue:@"hmm what" forKey:@"message"];
    
    [req startSynchronous];
    
    NSLog(@"Got HTTP status code from TwitPic: %d", [req responseStatusCode]);
    NSLog(@"Response string: %@", [req responseString]);
    NSDictionary *twitpicResponse = [[req responseString] JSONValue];
    textView.text = [NSString stringWithFormat:@"Posted image URL: %@", [twitpicResponse valueForKey:@"url"]];
    [req release];
    
}

// Twitter profile image post example.
// This returns a 200 response but does not seem to actually work, maybe due to a bug on Twitter side.
// See http://groups.google.com/group/twitter-development-talk/browse_thread/thread/df7102654c3077be/163abfbdcd24b8bf for updates.
-(IBAction)didPressPostProfileImage:(id)sender {
    NSString *postUrl = @"http://api.twitter.com/1/account/update_profile_image.json";
    ASIFormDataRequest *req = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:postUrl]];
    [req addRequestHeader:@"Authorization" value:[oAuth oAuthHeaderForMethod:@"POST" andUrl:postUrl andParams:nil]];
    
    [req setData:UIImageJPEGRepresentation(imageView.image, 0.8)
    withFileName:@"myProfileImage.jpg"
  andContentType:@"image/jpeg" forKey:@"image"];    
    
    [req startSynchronous];
    NSLog(@"Got HTTP status code from Twitter after posting profile image: %d", [req responseStatusCode]);
    NSLog(@"Response string: %@", [req responseString]);
    [req release];
}

#pragma mark -
#pragma mark UI configuration

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {	
    
    // Supports all but upside-down orientation.
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"image picker did finish");
    
    if ([UIDevice currentDevice].userInterfaceIdiom != UIUserInterfaceIdiomPad) {
        [self dismissModalViewControllerAnimated:YES];        
    } else {
        [popover dismissPopoverAnimated:YES];
    }
    
    imageView.image = [info valueForKey:UIImagePickerControllerEditedImage];
    
    postButton.hidden = NO;
    postProfileImageButton.hidden = NO;
    twitpicLabel.hidden = NO;
    profileLabel.hidden = NO;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"image picker did cancel");
    if ([UIDevice currentDevice].userInterfaceIdiom != UIUserInterfaceIdiomPad) {
        [self dismissModalViewControllerAnimated:YES];        
    } else {
        [popover dismissPopoverAnimated:YES];
    }
}


@end
