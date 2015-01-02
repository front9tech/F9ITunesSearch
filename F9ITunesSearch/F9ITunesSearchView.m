//
//  F9ITunesSearchView.m
//  F9ITunesSearch
//
//  Created by Scott Falbo on 11/30/14.
//  Copyright (c) 2014 Front9 Technologies. All rights reserved.
//

#import "F9ITunesSearchView.h"

@implementation F9ITunesSearchView

static NSString* kResultsUserInfoKey = @"results";

- (F9ITunesSearchView*) initWithSearchString:(NSString*)searchStr frame:(CGRect)frame textFont:(UIFont*)textFont {    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDataLoaded:) name:@"appDataLoaded" object:nil];
    F9ITunesSearchView* retval = [super initWithFrame:frame];
    retval.searchString = searchStr;
    
    self.appDataTextview = [[UITextView alloc] initWithFrame:CGRectMake(0, 100, retval.frame.size.width, retval.frame.size.height - 100)];
    self.appDataTextview.dataDetectorTypes = UIDataDetectorTypeAll;
    self.appDataTextview.editable = NO;
    self.appDataTextview.font = textFont;
    [retval addSubview:self.appDataTextview];
    
    return retval;
}

- (void) loadAppDetails:(int)appSearchType affiliateId:(NSString*)affiliateId {
    self.affiliateId = affiliateId;
    [self loadAppDetails:appSearchType];
}

- (void) loadAppDetails:(int)appSearchType {
    NSString *entityString = @"iPadSoftware";
    
    if (appSearchType == iPhoneAppType) {
        entityString = @"software";
    } else if (appSearchType == iPadAppType) {
        entityString = @"iPadSoftware";
    }
    
    NSString *urlAsString = [NSString stringWithFormat:@"https://itunes.apple.com/search?term=%@&country=us&entity=%@", self.searchString, entityString];
    urlAsString = [urlAsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    NSLog(@"%@", urlAsString);
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSError *localError = nil;
            NSDictionary *parsedObject = [[NSJSONSerialization JSONObjectWithData:data options:0 error:&localError] copy];
            
            NSDictionary *userInfo = @{kResultsUserInfoKey: parsedObject};
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"appDataLoaded" object:self userInfo:userInfo];
        }
    }];
}

-(void)appDataLoaded:(NSNotification *)notification {
    self.appDataTextview.text = @"";
    NSDictionary *userInfo = notification.userInfo;
    NSDictionary *parsedObject = [userInfo objectForKey:kResultsUserInfoKey];
    
    int resultCount = [[parsedObject valueForKey:@"resultCount"] intValue];
    NSArray *results = [parsedObject valueForKey:@"results"];
    NSLog(@"%i Results\n\n\n%@\n\n\n", resultCount, results);
    
    NSString *resultDisplayText = @"";
    
    if(results.count > 0) {
        NSDictionary *searchResult = (NSDictionary*)[results objectAtIndex:0];

        NSString *trackName = [searchResult objectForKey:@"trackName"];
        NSString *trackViewUrl = [searchResult objectForKey:@"trackViewUrl"];
        
        if (self.affiliateId != nil && ![self.affiliateId isEqualToString:@""]) {
            trackViewUrl = [trackViewUrl stringByAppendingFormat:@"&at=%@", self.affiliateId];
        }
        
        NSString *artistName = [searchResult objectForKey:@"artistName"];

        NSString *formattedPrice = [searchResult objectForKey:@"formattedPrice"];
        NSString *releaseDateStr = [searchResult objectForKey:@"releaseDate"];
        
        int userRatingCount = [[searchResult objectForKey:@"userRatingCount"] intValue];
        int userRatingCountForCurrentVersion = [[searchResult objectForKey:@"userRatingCountForCurrentVersion"] intValue];
        
        float averageUserRating = [[searchResult objectForKey:@"averageUserRating"] floatValue];
        float averageUserRatingForCurrentVersion = [[searchResult objectForKey:@"averageUserRatingForCurrentVersion"] floatValue];
        
        NSString *version = [searchResult objectForKey:@"version"];
        NSString *releaseNotes = [searchResult objectForKey:@"releaseNotes"];


        //Format the release date string into an NSDate
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        NSDate *releaseDate = [dateFormatter dateFromString:releaseDateStr];

        //Change the formatter to our display format
        [dateFormatter setDateFormat:@"EEEE MMMM dd, yyyy"];

        //Format the date
        NSString *formattedReleaseDate = [dateFormatter stringFromDate:releaseDate];
        
        resultDisplayText = [resultDisplayText stringByAppendingFormat:@"Search String: %@\n\n%@ by %@ (%@)\n\nApp URL: %@\n\nOriginally released on %@\n\nRated %.1f Stars (%i Ratings) All Time\n\nRated %.1f Stars (%i Ratings) since the latest release of Version %@\n\nVersion %@ Updates\n - %@", self.searchString, trackName, artistName, formattedPrice, trackViewUrl, formattedReleaseDate, averageUserRating, userRatingCount, averageUserRatingForCurrentVersion, userRatingCountForCurrentVersion, version, version, releaseNotes];
        
        //Load the Icon image
        NSString *artworkUrl100 = [searchResult objectForKey:@"artworkUrl100"];
        NSData *appIconImageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:artworkUrl100]];
        UIImage *appIconImage = [UIImage imageWithData:appIconImageData];

        UIImageView *appIconImageView = [[UIImageView alloc] initWithImage:appIconImage];
        appIconImageView.frame = CGRectMake(0, 0, 100, 100);
        [self addSubview:appIconImageView];
    } else {
        resultDisplayText = @"No apps found with this search value.";
    }
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        self.appDataTextview.text = resultDisplayText;
    });

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
