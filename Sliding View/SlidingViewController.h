//
//  SlidingViewController.h
//  Sliding View
//
//  Created by Tobin Schwaiger-Hastanan on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SlidingViewDelegate <NSObject>
- (UIView*) leftView;
- (UIView*) rightView;
@end

@interface SlidingViewController : UIViewController

- (id)initWithView:(UIView*) view delegate: (id<SlidingViewDelegate>) delegate;

- (void) switchTopView:(UIView*) newTopView;

- (void) close;
- (void) openLeftView;
- (void) openRightView;

@end
