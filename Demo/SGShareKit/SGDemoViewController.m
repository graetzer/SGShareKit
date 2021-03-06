//
//  SGDemoViewController.m
//  SGShareKit
//
//  Created by Simon Grätzer on 25.02.13.
//
//
//  Copyright 2013 Simon Peter Grätzer
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "SGDemoViewController.h"
#import "SGActivityView.h"


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
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
#else
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
#endif
}

- (IBAction)showShareController:(id)sender {
    NSString *text = @"Hello world";
    NSURL *url = [NSURL URLWithString:@"http://google.com"];
    NSURL *mail = [NSURL URLWithString:@"mailto:simon@graetzer.org"];
    SGActivityView *activity = [[SGActivityView alloc] initWithActivityItems:@[text, url, mail]
                                                       applicationActivities:nil];
    [activity show];
}

@end
