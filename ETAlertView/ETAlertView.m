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

- (void)awakeFromNib
{
    [super awakeFromNib];
    if (self) {
        // Initialization code
        [self configureView];
    }
}

#pragma mark - Configuration Methods

- (void)configureView {
    [self addSubview:[[[NSBundle mainBundle] loadNibNamed:@"ETAlertView" owner:self options:nil] objectAtIndex:0]];
    
    // Master
    [_masterView setExclusiveTouch:YES];
    [_masterView setBackgroundColor:[UIColor colorWithRed:0.38 green:0.38 blue:0.38 alpha:0.7]];
    
    // Box
    [_box.layer setCornerRadius:10.0];
    [_box.layer setShadowOffset:CGSizeMake(0.0, 1.0)];
    [_box.layer setShadowOpacity:1.0];
    [_box.layer setShadowRadius:1.0];
    [_box.layer setMasksToBounds:NO];
    
    // Message Box
    [_messageBox.layer setCornerRadius:10.0];
    [_messageBox.layer setMasksToBounds:NO];
    
    // Title
    [_title setTextColor:[UIColor colorWithWhite:0.165 alpha:1.000]];
    
    // Message
    [_mainMessage setTextColor:[UIColor colorWithWhite:0.165 alpha:1.000]];
}

#pragma mark - Initialization Methods

- (id)initWithTitle:(NSString *)title message:(NSString *)message confirmationButtonTitle:(NSString *)confirmationButtonTitle {
    return [self initWithTitle:title message:message negativeButtonTitle:nil positiveButtonTitle:confirmationButtonTitle];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message confirmationButtonTitle:(NSString *)confirmationButtonTitle confirmationBlock:(void (^)(void))confirmationBlock {
    return [self initWithTitle:title message:message negativeButtonTitle:nil positiveButtonTitle:confirmationButtonTitle negativeBlock:nil positiveBlock:confirmationBlock];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message negativeButtonTitle:(NSString *)negativeButtonTitle positiveButtonTitle:(NSString *)positiveButtonTitle {
    return [self initWithTitle:title message:message negativeButtonTitle:negativeButtonTitle positiveButtonTitle:positiveButtonTitle negativeBlock:nil positiveBlock:nil];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message negativeButtonTitle:(NSString *)negativeButtonTitle positiveButtonTitle:(NSString *)positiveButtonTitle negativeBlock:(void (^)(void))negativeBlock positiveBlock:(void (^)(void))positiveBlock {

    self = [self initWithFrame:CGRectZero];
    
    _leftBlock = negativeBlock;
    _rightBlock = positiveBlock;
    
    [_title setText:title];
    [_mainMessage setText:message];
    [_rightButton setTitle:positiveButtonTitle forState:UIControlStateNormal];
    
    if (negativeButtonTitle == nil) {
        [_rightButton setFrame:CGRectMake(_leftButton.frame.origin.x, _leftButton.frame.origin.y, _mainMessage.frame.size.width, _rightButton.frame.size.height)];
        [_leftButton removeFromSuperview];
    } else {
        [_leftButton setTitle:negativeButtonTitle forState:UIControlStateNormal];
    }
    
    return self;
}

#pragma mark - User Methods

- (void)show {
    
    // Get our key window
    UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;
    
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
}

- (IBAction)removeView:(id)sender {
    
    // Listen to window frame changes
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIApplicationDidChangeStatusBarFrameNotification" object:nil];
    
    // Call our callbacks
    if ((UIButton *)sender == _leftButton && _leftBlock != nil) {
        _leftBlock();
    } else if ((UIButton *)sender == _rightButton && _rightBlock != nil) {
        _rightBlock();
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
