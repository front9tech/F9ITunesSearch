F9ITunesSearch
==============

An Objective-C UIView that will search iTunes for an app and return the basic results. If you have an Apple Affiliate ID you can include this in the search result App Store Link.

![Demo Image](https://raw.githubusercontent.com/front9tech/F9ITunesSearch/master/F9ITunesSearch/F9ITunesSearch%20Screenshot.png)

### Usage

The F9ITunesSearchView is a subclass of UIView and can be dropped in where ever you may use a UIView.  

This control will allow you to provide a search string and provide you with details of the number 1 result on iTunes for the search string.  The control will get the icon and give you information about pricing, number of reviews, release date and more.

F9ITunesSearchView returns basic text information in a UITextView but we may want to provide different customizations for different viewing preferences and needs.

### How to Use
To use this control in your project simply copy F9ITunesSearchView.h and F9ITunesSearchView.m into your project.  

Once the files are in your project you need to import F9ITunesSearchView into the file where you are using it like so:
```
#import "F9ITunesSearchView.h"
```

Once the files are in your project and you've imported the F9ITunesSearchView.h header you can create a F9ITunesSearchView using the simple code below:
```
//Create an iTunes search view with your search string, frame size, and text font
F9ITunesSearchView *f9ITunesSearchView = [[F9ITunesSearchView alloc] initWithSearchString:@"Run the World GPS bugfoot" frame:CGRectMake(10, 20, self.view.frame.size.width - 20, self.view.frame.size.height - 40) textFont:[UIFont fontWithName:@"Avenir-Book" size:14.0]];

//Now do a search passing the app type (iPhone or iPad) and optionally your affiliate ID if you have one
//You can get an affiliate ID here if needed - https://www.apple.com/itunes/affiliates/
[f9ITunesSearchView loadAppDetails:iPhoneAppType affiliateId:@"10l7af"];

//Add the subview to your view
[self.view addSubview:f9ITunesSearchView];

```
