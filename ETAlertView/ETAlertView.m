//
//  ETAlertView.m
//  InEvent
//
//  Created by Pedro Góes on 14/10/12.
//  Copyright (c) 2012 Pedro Góes. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ETAlertView.h"

@implementation ETAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self configureView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self configureView];
    }
    return self;
}

#pragma mark - User Methods

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id<ETAlertViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle {
    
    self = [self initWithFrame:CGRectZero];
    
    self.delegate = delegate;
    
    [_title setText:title];
    [_message setTitle:message forState:UIControlStateNormal];
    [_yesButton setTitle:otherButtonTitle forState:UIControlStateNormal];
    
    if (cancelButtonTitle == nil) {
        [_yesButton setFrame:CGRectMake(_noButton.frame.origin.x, _noButton.frame.origin.y, _message.frame.size.width, _yesButton.frame.size.height)];
        [_noButton removeFromSuperview];
    } else {
        [_noButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
    }
    
    return self;
}

- (void)configureView {
    [self addSubview:[[[NSBundle mainBundle] loadNibNamed:@"ETAlertView" owner:self options:nil] objectAtIndex:0]];
    
    [_masterView setExclusiveTouch:YES];
    
    // Box
    [_box setBackgroundColor:[UIColor colorWithWhite:0.165 alpha:1.000]];
    [_box.layer setCornerRadius:10.0];
    [_box.layer setShadowColor:[[UIColor colorWithWhite:0.145 alpha:1.000] CGColor]];
    [_box.layer setShadowOffset:CGSizeMake(1.0, 1.0)];
    [_box.layer setShadowOpacity:1.0];
    [_box.layer setShadowRadius:1.0];
    [_box.layer setMasksToBounds:NO];
    [_box.layer setBorderWidth:4.0];
    [_box.layer setBorderColor:[[UIColor colorWithWhite:0.165 alpha:1.000] CGColor]];
    
    // Message Box
    [_messageBox.layer setCornerRadius:6.0];
    [_messageBox.layer setMasksToBounds:NO];
    
    // Title
    [_title setTextColor:[UIColor colorWithWhite:0.965 alpha:1.000]];
    
    // Message
    [_message.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_message setTitleColor:[UIColor colorWithWhite:0.165 alpha:1.000] forState:UIControlStateNormal];
}

- (void)show {
    
    // Get our key window
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    // Get all the bounds
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGRect frame = CGRectMake(0, 0, bounds.size.width, bounds.size.height);
    self.frame = frame;
    
    // Centralize the box
    _box.frame = CGRectMake((frame.size.width - _box.frame.size.width) / 2.0f, (frame.size.height - _box.frame.size.height) / 2.0, _box.frame.size.width, _box.frame.size.height);
    
    // Listen to window frame changes 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarDidChangeFrame:) name:@"UIApplicationDidChangeStatusBarFrameNotification" object:nil];
    
    // We don't need to send a notification
    [self statusBarDidChangeFrame:nil];
    
    // Make the transition
    [UIView transitionWithView:keyWindow duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [keyWindow addSubview:self];
    } completion:NULL];
    
//    [self pulse];
}

- (IBAction)removeView:(id)sender {
    
    // Listen to window frame changes
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIApplicationDidChangeStatusBarFrameNotification" object:nil];
    
    if ([_delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        if ((UIButton *)sender == _noButton) {
            [_delegate alertView:self clickedButtonAtIndex:0];
        } else {
            [_delegate alertView:self clickedButtonAtIndex:1];
        }
    }
    
    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [self removeFromSuperview];
    } completion:NULL];
}

- (void)pulse {
	// pulse animation thanks to:  http://delackner.com/blog/2009/12/mimicking-uialertviews-animated-transition/
    self.transform = CGAffineTransformMakeScale(0.6, 0.6);
	[UIView animateWithDuration: 0.2
					 animations: ^{
						 self.transform = CGAffineTransformMakeScale(1.1, 1.1);
					 }
					 completion: ^(BOOL finished){
						 [UIView animateWithDuration:1.0/15.0
										  animations: ^{
											  self.transform = CGAffineTransformMakeScale(0.9, 0.9);
										  }
										  completion: ^(BOOL finished){
											  [UIView animateWithDuration:1.0/7.5
															   animations: ^{
																   self.transform = CGAffineTransformIdentity;
															   }];
										  }];
					 }];
    
}

#pragma mark - Rotation

#define DegreesToRadians(degrees) (degrees * M_PI / 180)

- (CGAffineTransform)transformForOrientation:(UIInterfaceOrientation)orientation {
    
    switch (orientation) {
            
        case UIInterfaceOrientationLandscapeLeft:
            return CGAffineTransformMakeRotation(-DegreesToRadians(90));
            
        case UIInterfaceOrientationLandscapeRight:
            return CGAffineTransformMakeRotation(DegreesToRadians(90));
            
        case UIInterfaceOrientationPortraitUpsideDown:
            return CGAffineTransformMakeRotation(DegreesToRadians(180));
            
        case UIInterfaceOrientationPortrait:
        default:
            return CGAffineTransformMakeRotation(DegreesToRadians(0));
    }
}

- (void)statusBarDidChangeFrame:(NSNotification *)notification {
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    [self setTransform:[self transformForOrientation:orientation]];
}

@end
