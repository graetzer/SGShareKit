//
//  SGDemoViewController.m
//  SGShareKit
//
//  Created by Simon Grätzer on 25.02.13.
//  Copyright (c) 2013 Simon Peter Grätzer. All rights reserved.
//

#import "SGDemoViewController.h"
#import "SGShareView.h"
#import "SGShareView+UIKit.h"


@implementation SGDemoViewController

- (BOOL)shouldAutorotate {
    return YES;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (void)viewDidLoad {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Share" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 100, 40);
    button.center = self.view.center;
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [button addTarget:self action:@selector(showShareController:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:button];
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
}

- (IBAction)showShareController:(id)sender {
    SGShareView *share = [SGShareView shareView];
    share.initialText = @"Hello World!";
    [share addURL:[NSURL URLWithString:@"http://google.com"]];
    [share show];
}

@end
