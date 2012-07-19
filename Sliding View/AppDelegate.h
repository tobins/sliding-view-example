//
//  AppDelegate.h
//  Sliding View
//
//  Created by Tobin Schwaiger-Hastanan on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SlidingViewController.h"

@class LeftViewController;
@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, SlidingViewDelegate>

@property (strong, nonatomic) LeftViewController* leftViewController;
@property (strong, nonatomic) SlidingViewController *slidingViewController;
@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) UIWindow *window;

@end
