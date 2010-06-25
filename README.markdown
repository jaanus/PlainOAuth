# PlainOAuth

An Objective-C library implementing OAuth protocol and some Twitter convenience methods, and an example iPhone app demonstrating its use.

Jaanus Kase, <http://www.jaanuskase.com>

## Motivation

I wanted to learn more about the OAuth protocol: specifically how to implement it in Objective-C and how to use Twitter with OAuth. I looked at some other libraries, but they felt too bloated for me. They overloaded NSURLRequest and/or some Twitter library in all sorts of weird ways.

I want my apps to use independent, focused libraries. This library therefore ONLY implements the basic OAuth signature and header generation; no more, no less. Additionally, it is right now somewhat coupled to Twitter, and contains some convenience methods for working with Twitter. Making it work with some other OAuth provider may need some decoupling.

This is also a learning project for me to understand how to architect your app around OAuth, as well as how to develop universal apps and portrait+landscape layout support with the least effort.

## How to get started

1. Register your app with Twitter at http://dev.twitter.com/apps
1. Get the PlainOAuth code.
1. Edit OAuthConsumerCredentials.h with your consumer key and secret that Twitter gives you, and remove the error.
1. Compile and run.

I have tested the example app in Xcode 3.2.3 on iPhone with iOS 4, and iPad with iOS 3.2. It runs fine both on simulator and the devices. It may not work on earlier iPhone OS-es below 3.0.

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

## Change log

### January 2010

Initial release.

### June 24, 2010

A major rewrite. The OAuth core has not changed, but the example app has gotten a major rewrite and is now much easier to read. I tried to make the architecture more approachable.

* Universal app. The app now works on iPhone and iPad, and supports both landscape and portrait modes. Getting the rotations and UI to work reasonably well took me longer than expected, but the end result seems to be quite approachable.

* Embedded browser. The previous example took you out of the app and into Safari to get the PIN. While secure, this experience was sub-par. The new version uses an embedded UIWebView to load the PIN from Twitter.

* Better designed reference login UI. The login UI is not a random hack anymore; it actually has some design and layout. I took the login UI from [Crème](http://cremeapp.com) and am hereby releasing it to public use. Feel free to use it in your own apps.

* GET example. Doing GET with OAuth may be tricky and I got some questions about it, as you have to give OAuth the normalized URL and parameters separately, yet you merge them when constructing your actual HTTP request. This example should take away some confusion.

* Refactored delegates. TwitterLoginPopup now uses two delegates: delegate<TwitterLoginPopupDelegate> for final authorization and canceling messages, and uiDelegate<TwitterLoginUiFeedback> for progress feedback. The example app shows how to use these with a very simplistic activity indicator, but you can of course do something much more elaborate. You can see one example in [Crème](http://cremeapp.com) with a native-style transparent overlay.

Subclassing note: you may want to subclass TwitterLoginPopup similarly as is done in this app. Some of the things you could then do are to set the navigation title bar tint, override shouldAutorotateToInterfaceOrientation: if you only support some particular rotations in your app, and incorporate some UI element for progress feedback as is done here with a very basic activity indicator.

## TODO

* OAuth Echo example: how to post a picture to TwitPic and other sites that already support OAuth Echo

## Read more on my blog

Here are three posts on the background of this, that may help you understand this code better.

[New version of PlainOAuth, the example Twitter OAuth app for iPhone](http://www.jaanuskase.com/en/2010/06/new_version_of_plainoauth_the.html)

[Understanding the guts of Twitter's OAuth for client apps](http://www.jaanuskase.com/en/2010/01/an_example_iphone_twitter_app.html)

[An example iPhone Twitter app with OAuth authentication](http://www.jaanuskase.com/en/2010/01/an_example_iphone_twitter_app.html)

## Acknowledgements

I use the work of several others:

[OAuth Consumer](http://code.google.com/p/oauthconsumer/) by Jon Crosby. I have included some code from this project, specifically NSString URL-encoding, base64 and crypto. There is an "iPhone-ready" version of this library [here](http://github.com/jdg/oauthconsumer).

[ASIHTTPRequest](http://allseeing-i.com/ASIHTTPRequest/) for HTTP. This is only for example app and Twitter convenience methods; the core OAuth implementation does not do HTTP.

[Tweepy.](http://github.com/joshthecoder/tweepy) This is a nice Twitter API implementation in Python (including OAuth) that was helpful in understanding the protocol.

[Stack Overflow](http://stackoverflow.com) has been invaluable to me in learning about miscellaneous iPhone development.

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
