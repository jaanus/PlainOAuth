# PlainOAuth

An Objective-C library implementing OAuth protocol and some Twitter convenience methods, and an example iPhone app demonstrating its use.

Jaanus Kase, <http://www.jaanuskase.com>

## How to get started

1. Register your app with Twitter at http://dev.twitter.com/apps
1. Get the PlainOAuth code.
1. Edit OAuthConsumerCredentials.h with your consumer key and secret that Twitter gives you, and remove the error.
1. Compile and run.

I have tested the example app in Xcode 3.2.3 on iPhone with iOS 4, and iPad with iOS 3.2. It runs fine both on simulator and the devices. It may not work on earlier iPhone OS-es below 3.0.

## Change log

### December 18, 2011

* Upgraded SBJson version to 3.1, no more naming conflict with JSON.framework.
* Completed Foursquare demo UI implementation.
* Moved Twitter delegate from OAuth to OAuthTwitter subclass.

### November 27, 2011

* Created a top-level UI that supports more than just Twitter. Implemented Twitter OAuth as a child of the parent UI.
* Incomplete Foursquare implementation. Loads the login UI but does not process the results yet.

### November 13, 2011

A number of changes supporting the longer-term goals of adding other example OAuth providers besides Twitter, and moving the project to ARC model.

* Upgraded linked libz version to compile with latest Xcode/iOS SDK (5.0).
* Removed ASIHTTPRequest dependencies, now using NSURL* throughout the app.
* Refactored to clearly separate the OAuth core and provider-specific methods and variables. Made OAuthTwitter a subclass of the core, and other providers will follow the same model.

### August 28, 2011

* Moved some private method signature definitions from OAuth.h to OAuth.m into a private category.
* Added unit tests for UTF-8 parameter keys and values.
* Added UTF-8 encoding of parameter keys (thanks, @h-lame).

### April 13, 2011

* Fixed a memory leak.

### April 9, 2011

* Twitter seems to have fixed their infrastructure problems with token authorization API call, the delay is no longer necessary, removed.

### April 1, 2011

* Added a five-second delay to the token authorization API call, to work around a Twitter API bug. See https://twitter.com/#!/twitterapi/status/53836545618219008.

### March 24, 2011

* Updated Twitter OAuth API URL-s to match documentation.
* More debugging output when token authorization fails.
* Misc small fixes and Xcode warning fix.

### March 13, 2011

* Fixed compilation error with Xcode 4 (previously, complained about missing architectures.)

### January 30, 2011

* Added handling of URL callback-based flow in addition to PIN-based flow. URL callback is more streamlined, as you don’t need the user to input PIN or click a button to start the process.

Note that there are a few things you must do to make sure your URL callback-based flow works.

* Switch your app type in Twitter backend from “Client” to “Browser.” According to my testing, the “Browser” app type can handle both PIN- and URL-based flows. When you pass “oob” as the callback URL to “Browser” app, it behaves as a PIN-based app. The opposite (passing a non-OOB URL to PIN-based app) yields an error.
* When instatiating TwitterLoginPopup, make sure to set its flowType to TwitterLoginCallbackFlow, and set the oAuthCallbackUrl property to the URL of your app.
* Declare in your app’s info.plist that you can handle the URL schema that you use in oAuthCallbackUrl.
* Implement application:openURL:sourceApplication:annotation: in your app delegate to receive the oauth\_verifier that Twitter gives you.
* Call through to the authorizeOAuthVerifier: method of TwitterLoginPopup from your URL handler.

All of the above is demonstrated in the PlainOAuth example app.

### October 12, 2010

* Updated graphics with Retina versions, fixed text layout, login UI now looks good on Retina display.

### September 26, 2010

* Included an example of how to add additional POST parameters when posting a status, e.g to add location.

### September 24, 2010

* Fixed a layout problem with the “Get PIN from Twitter” button. Text was sometimes truncated.

### August 9, 2010

* Re-enable the "get PIN" link if token request fails.

* Now sending "oauth_callback=oob" parameter when requesting the original token, per Twitter’s recommendation. (http://twitter.com/episod/status/20722145979)

### July 31, 2010

* Fixed a crash when user tapped on "get PIN" link quickly twice in a row. (Thanks Matthew Mattson.)

### July 14, 2010

* Fixed a double-encoding problem in OAuth authorization header. (Thanks Chris Burkhardt.)

* Profile image upload example. Twitter returns a 200 OK response, but the image does not actually show up, possibly due to a bug in Twitter servers. See [this](http://groups.google.com/group/twitter-development-talk/browse_thread/thread/bd560e9866081639) and [this](http://groups.google.com/group/twitter-development-talk/browse_thread/thread/df7102654c3077be) Twitter API discussion thread for updates.

### July 3, 2010

* UI detail: Twitter status field now resigns first responder after each post or when you press some other button in the UI, so you could see the controls below.

* Demo of image uploading to TwitPic with OAuth Echo authentication.

### June 24, 2010

A major rewrite. The OAuth core has not changed, but the example app has gotten a major rewrite and is now much easier to read. I tried to make the architecture more approachable.

* Universal app. The app now works on iPhone and iPad, and supports both landscape and portrait modes. Getting the rotations and UI to work reasonably well took me longer than expected, but the end result seems to be quite approachable.

* Embedded browser. The previous example took you out of the app and into Safari to get the PIN. While secure, this experience was sub-par. The new version uses an embedded UIWebView to load the PIN from Twitter.

* Better designed reference login UI. The login UI is not a random hack anymore; it actually has some design and layout. I took the login UI from [Crème](http://cremeapp.com) and am hereby releasing it to public use. Feel free to use it in your own apps.

* GET example. Doing GET with OAuth may be tricky and I got some questions about it, as you have to give OAuth the normalized URL and parameters separately, yet you merge them when constructing your actual HTTP request. This example should take away some confusion.

* Refactored delegates. TwitterLoginPopup now uses two delegates: delegate<TwitterLoginPopupDelegate> for final authorization and canceling messages, and uiDelegate<TwitterLoginUiFeedback> for progress feedback. The example app shows how to use these with a very simplistic activity indicator, but you can of course do something much more elaborate. You can see one example in [Crème](http://cremeapp.com) with a native-style transparent overlay.

Subclassing note: you may want to subclass TwitterLoginPopup similarly as is done in this app. Some of the things you could then do are to set the navigation title bar tint, override shouldAutorotateToInterfaceOrientation: if you only support some particular rotations in your app, and incorporate some UI element for progress feedback as is done here with a very basic activity indicator.

### January 2010

Initial release.

## Motivation

I wanted to learn more about the OAuth protocol: specifically how to implement it in Objective-C and how to use Twitter with OAuth. I looked at some other libraries, but they felt too bloated for me. They overloaded NSURLRequest and/or some Twitter library in all sorts of weird ways.

I want my apps to use independent, focused libraries. This library therefore ONLY implements the basic OAuth signature and header generation; no more, no less. Additionally, it is right now somewhat coupled to Twitter, and contains some convenience methods for working with Twitter. Making it work with some other OAuth provider may need some decoupling.

This is also a learning project for me to understand how to architect your app around OAuth, as well as how to develop universal apps and portrait+landscape layout support with the least effort.

## Features

### Simple API

For a simple REST GET request for no parameters, all you need is this (assuming you already have an authorized token):

    #import "OAuth.h"

    OAuth *oAuth = [[OAuth alloc] initWithConsumerKey:myKey andConsumerSecret:mySecret];
    oAuth.oauth_token = a_previously_obtained_and_authorized_token;
    oAuth.oauth_token_secret = a_previously_obtained_and_authorized_secret;
    oAuth.oauth_token_authorized = YES;
    NSString *requestHeader = [oAuth oAuthHeaderForMethod:@"GET" andUrl:@"http://example.provider/example/command" andParams:nil];
    [myHttpLibrary addHeaderValue:requestHeader forHeader:@"Authorization"];
    [oAuth release];

### Twitter convenience methods

These let you easily complete the authentication sequence:

    [oAuth synchronousRequestToken];
    [oAuth synchronousAuthorizeTokenWithVerifier:<pin you got from user>];

See OAuth.h, OAuth.m and the example app for a complete example.

### No threading

If you use the Twitter convenience methods, all HTTP calls are synchronous. This lets you do threading in a way that you like most yourself. The example app shows one possible approach.

## Required frameworks

If you copy PlainOAuth code to your app, make sure you have the following frameworks added to your project.

* MobileCoreServices.framework
* Security.framework
* CFNetwork.framework
* libz.1.2.3.dylib
* SystemConfiguration.framework
* UIKit.framework
* Foundation.framework
* CoreGraphics.framework

## Read more on my blog

Here are three posts on the background of this, that may help you understand this code better.

[New version of PlainOAuth, the example Twitter OAuth app for iPhone](http://jaanus.com/post/1451098734/new-version-of-plainoauth-the)

[Understanding the guts of Twitter's OAuth for client apps](http://jaanus.com/post/1451098316/understanding-the-guts-of-twit)

[An example iPhone Twitter app with OAuth authentication](http://jaanus.com/post/1451098350/an-example-iphone-twitter-app)

## Acknowledgements

I use the work of several others:

[OAuth Consumer](http://code.google.com/p/oauthconsumer/) by Jon Crosby. I have included some code from this project, specifically NSString URL-encoding, base64 and crypto. There is an "iPhone-ready" version of this library [here](http://github.com/jdg/oauthconsumer).

[ASIHTTPRequest](http://allseeing-i.com/ASIHTTPRequest/) for HTTP. This is only for example app and Twitter convenience methods; the core OAuth implementation does not do HTTP. (I used this library in the earlier versions of PlainOAuth. I am trying to cut down the dependencies other than Apple core libraries and am no longer using ASIHTTPRequest.)

[Tweepy.](http://github.com/joshthecoder/tweepy) This is a nice Twitter API implementation in Python (including OAuth) that was helpful in understanding the protocol.

[Stack Overflow](http://stackoverflow.com) has been invaluable to me in learning about miscellaneous iPhone development.

## Donations

If you found this project useful, please donate. There’s no expected amount and I don’t require you to. Completely up to you. You can do it with Pledgie or Flattr.

<a href='http://www.pledgie.com/campaigns/8041'><img alt='Click here to lend your support to: PlainOAuth and make a donation at www.pledgie.com !' src='http://www.pledgie.com/campaigns/8041.png?skin_name=chrome' border='0' /></a>

[![Flattr this git repo](http://api.flattr.com/button/flattr-badge-large.png)](https://flattr.com/submit/auto?user_id=jaanus&url=https://github.com/jaanus/PlainOAuth&title=PlainOAuth&language=&tags=github&category=software)

## License (MIT)

Copyright (c) 2010 Jaanus Kase

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
