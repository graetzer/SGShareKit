//
//  SGAppDelegate.m
//  SGShareKit
//
//  Created by Simon Grätzer on 23.02.13.
//  Copyright (c) 2013 Simon Peter Grätzer. All rights reserved.
//

#import "SGAppDelegate.h"
#import "SGDemoViewController.h"

@implementation SGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [SGDemoViewController new];
    [self.window makeKeyAndVisible];

    return YES;
}

@end
