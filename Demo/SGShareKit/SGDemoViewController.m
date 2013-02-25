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
