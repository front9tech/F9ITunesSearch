//
//  ViewController.m
//  F9ITunesSearch
//
//  Created by Scott Falbo on 11/30/14.
//  Copyright (c) 2014 Front9 Technologies. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    F9ITunesSearchView *f9ITunesSearchView = [[F9ITunesSearchView alloc] initWithSearchString:@"Run the World GPS bugfoot" frame:CGRectMake(10, 20, self.view.frame.size.width - 20, self.view.frame.size.height - 40) textFont:[UIFont fontWithName:@"Avenir-Book" size:14.0]];
    
    [f9ITunesSearchView loadAppDetails:iPhoneAppType affiliateId:@"10l7af"];
    [self.view addSubview:f9ITunesSearchView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
