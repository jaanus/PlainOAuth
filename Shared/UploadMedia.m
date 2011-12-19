//
//  UploadMedia.m
//  PlainOAuth
//
//  Created by Jaanus Kase on 03.07.10.
//  Copyright 2010. All rights reserved.
//

#import "UploadMedia.h"
#import "OAuth.h"
#import "SBJson.h"
#import "OAuthConsumerCredentials.h"
#import "NSString+URLEncoding.h"

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
    
    NSString *url = @"http://api.twitpic.com/2/upload.json";
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [req setValue:@"https://api.twitter.com/1/account/verify_credentials.json" forHTTPHeaderField:@"X-Auth-Service-Provider"];
    [req setValue:[oAuth oAuthHeaderForMethod:@"GET"
                                       andUrl:@"https://api.twitter.com/1/account/verify_credentials.json"
                                    andParams:nil] forHTTPHeaderField:@"X-Verify-Credentials-Authorization"];      
    
    NSData *imageData = UIImageJPEGRepresentation(imageView.image, 0.8);
    
    [req setHTTPMethod:@"POST"];

    // Image uploading and form construction technique with NSURLRequest: http://www.cocoanetics.com/2010/02/uploading-uiimages-to-twitpic/
    
    // Just some random text that will never occur in the body
    NSString *stringBoundary = @"0xKhTmLbOuNdArY---This_Is_ThE_BoUnDaRyy---pqo";
    
    // Header value
    NSString *headerBoundary = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",
                                stringBoundary];
    
    // Set header
    [req addValue:headerBoundary forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *postBody = [NSMutableData data];
    
    // Twitpic API key
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"key\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    // Define this TWITPIC_API_KEY somewhere or replace with your own key inline right here.
    [postBody appendData:[TWITPIC_API_KEY dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // TwitPic API doc says that message is mandatory, but looks like
    // it's actually optional in practice as of July 2010. You may or may not send it, both work.
    /* [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"message\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"oh hai!!!" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]]; */
    
    // media part
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Disposition: form-data; name=\"media\"; filename=\"dummy.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Type: image/jpeg\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add it to body
    [postBody appendData:imageData];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // final boundary
    [postBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [req setHTTPBody:postBody];
        
    NSHTTPURLResponse *response;
    NSError *error = nil;
    
    NSString *responseString = [[[NSString alloc] initWithData:[NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error] encoding:NSUTF8StringEncoding] autorelease];
    
    if (error) {
        NSLog(@"Error from NSURLConnection: %@", error);        
    }    
    NSLog(@"Got HTTP status code from TwitPic: %d", [response statusCode]);
    NSLog(@"Response string: %@", responseString);
    NSDictionary *twitpicResponse = [responseString JSONValue];
    textView.text = [NSString stringWithFormat:@"Posted image URL: %@", [twitpicResponse valueForKey:@"url"]];
    
}

// Twitter profile image post example.
-(IBAction)didPressPostProfileImage:(id)sender {
    NSString *postUrl = @"http://api.twitter.com/1/account/update_profile_image.json";
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:postUrl]];
    [req setValue:[oAuth oAuthHeaderForMethod:@"POST" andUrl:postUrl andParams:nil] forHTTPHeaderField:@"Authorization"];
    [req setHTTPMethod:@"POST"];
    
    // Just some random text that will never occur in the body
    NSString *stringBoundary = @"0xKhTmLbOuNdArY---This_Is_ThE_BoUnDaRyy---pqo";
    
    // Header value
    NSString *headerBoundary = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",
                                stringBoundary];
    
    // Set header
    [req addValue:headerBoundary forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *postBody = [NSMutableData data];
    
    // media part
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Disposition: form-data; name=\"image\"; filename=\"myProfileImage.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Type: image/jpeg\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add it to body
    [postBody appendData:UIImageJPEGRepresentation(imageView.image, 0.8)];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // final boundary
    [postBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [req setHTTPBody:postBody];

    NSHTTPURLResponse *response;
    NSError *error = nil;
    
    NSString *responseString = [[[NSString alloc] initWithData:[NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error] encoding:NSUTF8StringEncoding] autorelease];
    
    if (error) {
        NSLog(@"Error from NSURLConnection: %@", error);        
    }
    NSLog(@"Got HTTP status code from Twitter after posting profile image: %d", [response statusCode]);
    NSLog(@"Response string: %@", responseString);
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
