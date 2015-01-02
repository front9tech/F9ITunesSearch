//
//  F9ITunesSearchView.h
//  F9ITunesSearch
//
//  Created by Scott Falbo on 11/30/14.
//  Copyright (c) 2014 Front9 Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface F9ITunesSearchView : UIView

typedef enum AppSearchType : unsigned int {
    iPhoneAppType,
    iPadAppType
} AppSearchType;


@property (nonatomic, strong) NSString *searchString;
@property (nonatomic, strong) UITextView *appDataTextview;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) NSString *affiliateId;

- (F9ITunesSearchView*) initWithSearchString:(NSString*)searchStr frame:(CGRect)frame textFont:(UIFont*)textFont;

- (void) loadAppDetails:(int)appSearchType;
- (void) loadAppDetails:(int)appSearchType affiliateId:(NSString*)affiliateId;
- (void) appDataLoaded:(NSNotification *)notification;

@end
