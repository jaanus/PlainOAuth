# PlainOAuth

An Objective-C library implementing OAuth protocol and some Twitter convenience methods, and an example iPhone app demonstrating its use.

Jaanus Kase, <http://www.jaanuskase.com>

## Motivation

I wanted to learn more about the OAuth protocol: specifically how to implement it in Objective-C and how to use Twitter with OAuth. I looked at some other libraries, but they felt too bloated for me. They overloaded NSURLRequest and/or some Twitter library in all sorts of weird ways.

I want my apps to use independent, focused libraries. This library therefore ONLY implements the basic OAuth signature and header generation; no more, no less. Additionally, it is right now somewhat coupled to Twitter, and contains some convenience methods for working with Twitter. Making it work with some other OAuth provider may need some decoupling.

I also am not aware of any iPhone Twitter apps on the market today that authenticate people with OAuth. I therefore made a simple example UI.

## How to get started

1. Register your app with Twitter at http://twitter.com/oauth_clients
1. Get the PlainOAuth code.
1. Edit OAuthConsumerCredentials.h with your consumer key and secret that Twitter gives you, and remove the error.
1. Compile and run.

I have tested the example app in Xcode 3.1.4 and iPhone OS 3.1. It runs fine both on simulator and device. It may not work on earlier iPhone OS-es.

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

## TODO

* Decouple Twitter and generic stuff
* Better documentation?

## Read more on my blog

Here are two posts on the background of this, that may help you understand this code better.

[Understanding the guts of Twitter's OAuth for client apps](http://www.jaanuskase.com/en/2010/01/an_example_iphone_twitter_app.html)

[An example iPhone Twitter app with OAuth authentication](http://www.jaanuskase.com/en/2010/01/an_example_iphone_twitter_app.html)

## Acknowledgements

I use the work of several others:

[OAuth Consumer](http://code.google.com/p/oauthconsumer/) by Jon Crosby. I have included some code from this project, specifically NSString URL-encoding, base64 and crypto. There is an "iPhone-ready" version of this library [here](http://github.com/jdg/oauthconsumer).

[ASIHTTPRequest](http://allseeing-i.com/ASIHTTPRequest/) for HTTP. This is only for example app and Twitter convenience methods; the core OAuth implementation does not do HTTP.

[Tweepy.](http://github.com/joshthecoder/tweepy) This is a nice Twitter API implementation in Python (including OAuth) that was helpful in understanding the protocol.

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
