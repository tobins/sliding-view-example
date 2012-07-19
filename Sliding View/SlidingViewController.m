//
//  SlidingViewController.m
//  Sliding View
//
//  Created by Tobin Schwaiger-Hastanan on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SlidingViewController.h"
#import "QuartzCore/CALayer.h"

@interface SlidingViewController () {
    CGRect frameStart;
    BOOL trayOpen;
}

@property (strong, nonatomic) id<SlidingViewDelegate> delegate;
@property (strong, nonatomic) UIGestureRecognizer* panGesture;
@property (strong, nonatomic) UIGestureRecognizer* tapGesture;
@property (strong, nonatomic) UIView *topView;

@end

@implementation SlidingViewController

@synthesize delegate = _delegate;
@synthesize panGesture;
@synthesize tapGesture;
@synthesize topView;

- (id)init {
    // calling the default init method is not allowed, this will raise an exception if it is called.
    if( self = [super init] ) {
        [self doesNotRecognizeSelector:_cmd];
    }
    return nil;
}

- (id)initWithView:(UIView*) view delegate: (id<SlidingViewDelegate>) delegate
{
    if (self = [super init]) {
        _delegate = delegate;
        self.topView = view;
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [self addShadow: self.topView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if( self.view != self.topView.superview ) {
        self.topView.frame = CGRectMake( 0, 0, self.view.frame.size.width, self.view.frame.size.height );
        [[self view] addSubview: self.topView];        
        [self.topView addGestureRecognizer:self.panGesture];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) addShadow:(UIView*) view {
    // set up drop shadow
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOpacity = 0.75f;
    view.layer.shadowOffset = CGSizeMake(0, 0);
    view.layer.shadowRadius = 3.0f;
    view.layer.masksToBounds = NO;
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGSize size = view.bounds.size;
    [path moveToPoint:CGPointMake(0, -5)];
    [path addLineToPoint:CGPointMake(size.width, -5)];
    [path addLineToPoint:CGPointMake(size.width, size.height+5 )];
    [path addLineToPoint:CGPointMake(0, size.height+5)];
    view.layer.shadowPath = path.CGPath;
}

- (void) switchTopView:(UIView*) newTopView {
    newTopView.frame = CGRectMake(  0, 0, self.view.frame.size.width, self.view.frame.size.height );
    [self addShadow:newTopView];
    
    if( [self.delegate leftView].superview == self.view ) {        
        [UIView animateWithDuration:0.20
                              delay:0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             CGRect frame = CGRectMake(self.topView.frame.size.width, 0, self.topView.frame.size.width, self.topView.frame.size.height );
                             self.topView.frame = frame;
                             
                         } 
                         completion:^(BOOL finished) {
                             [self.topView removeFromSuperview];
                             [self.topView removeGestureRecognizer:self.panGesture];
                             
                             self.topView = newTopView;
                             
                             [[self view] addSubview: self.topView];
                             self.topView.frame = CGRectMake( self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height );
                             [self.topView addGestureRecognizer:panGesture];
                             [self close];
                         }];        
    }    
}

-(void) close {
    [UIView animateWithDuration:0.25
                          delay:0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGRect frame = CGRectMake(0, 0, self.topView.frame.size.width, self.topView.frame.size.height );
                         self.topView.frame = frame;
                         
                     } 
                     completion:^(BOOL finished) {
                         if( [self.delegate leftView].superview == self.view ) {
                             [[self.delegate leftView] removeFromSuperview];
                         } else if( [self.delegate rightView].superview == self.view ) {
                             [[self.delegate rightView] removeFromSuperview];
                         }
                         
                         [self.topView removeGestureRecognizer:self.tapGesture];
                         
                         trayOpen = NO;
                     }];
}

-(void) openLeftView {
    if( [self.delegate rightView].superview == self.view ) {
        [[self.delegate rightView] removeFromSuperview];
    }
    
    [self.view insertSubview:[self.delegate leftView] belowSubview: self.topView];
    [self.delegate leftView].frame = CGRectMake( 0, 0, self.view.frame.size.width, self.view.frame.size.height );
    
    [UIView animateWithDuration:0.25
                          delay:0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGRect frame = CGRectMake(self.topView.frame.size.width - 40, 0, self.topView.frame.size.width, self.topView.frame.size.height );
                         self.topView.frame = frame;
                         
                     } 
                     completion:^(BOOL finished) {
                         [self.topView addGestureRecognizer:self.tapGesture];
                         trayOpen = YES;
                     }];
}

-(void) openRightView {
    [UIView animateWithDuration:0.25
                          delay:0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGRect frame = CGRectMake( 40 - self.topView.frame.size.width, 0, self.topView.frame.size.width, self.topView.frame.size.height );
                         self.topView.frame = frame;
                         
                     } 
                     completion:^(BOOL finished) {
                         [self.topView addGestureRecognizer:self.tapGesture];
                         trayOpen = YES;
                     }];
}

#pragma mark Gesture handlers

- (IBAction)handlePanGesture:(UIPanGestureRecognizer *)sender {
    CGPoint translate = [sender translationInView:self.view];
    
    if( sender.state == UIGestureRecognizerStateBegan ) {
        frameStart = self.topView.frame;
    }
    CGRect newFrame = frameStart;
    
    newFrame.origin.x += translate.x;
    if( [self.delegate leftView] == nil && newFrame.origin.x > 0 ) {
        newFrame.origin.x = 0;
    } else if( [self.delegate leftView] != nil && 
              newFrame.origin.x > 0 && 
              [self.delegate leftView].superview != self.view ) {
        
        if( [self.delegate rightView].superview == self.view ) {
            [[self.delegate rightView] removeFromSuperview];
        }
        
        [[self view] insertSubview:[self.delegate leftView] belowSubview: self.topView];
        [self.delegate leftView].frame = CGRectMake( 0, 0, self.view.frame.size.width, self.view.frame.size.height );   
    }
    
    if([self.delegate rightView] == nil && newFrame.origin.x < 0 ) {
        newFrame.origin.x = 0;
    } else if ( [self.delegate rightView] != nil && 
               newFrame.origin.x > 0 && 
               [self.delegate rightView].superview != self.view ) {
        
        if( [self.delegate leftView].superview == self.view ) {
            [[self.delegate leftView] removeFromSuperview];
        }
        
        [[self view] insertSubview:[self.delegate rightView] belowSubview: self.topView];
        [self.delegate rightView].frame = CGRectMake( 0, 0, self.view.frame.size.width, self.view.frame.size.height );        
    }
    
    
    sender.view.frame = newFrame;
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        self.topView.frame = newFrame;
        if(  [self.delegate leftView].superview == self.view ) {
            if( !trayOpen ) {
                if( newFrame.origin.x > 40 ) {
                    [self openLeftView];
                } else {
                    [self close];             
                }
            } else {
                if( newFrame.origin.x < 320-40 ) {
                    [self close];
                    
                } else {
                    [self openLeftView];                    
                }                
            }
        } else {
            if( !trayOpen ) {
                if( newFrame.origin.x < -40 ) {
                    [self openRightView];
                } else {
                    [self close];             
                }
            } else {
                if( newFrame.origin.x > 40-320 ) {
                    [self close];
                    
                } else {
                    [self openRightView];                    
                }                
            }            
        }
    }
}

- (IBAction)handleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self close];
    }
}
@end
