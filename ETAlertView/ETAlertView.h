//
//  ETAlertView.h
//  InEvent
//
//  Created by Pedro Góes on 14/10/12.
//  Copyright (c) 2012 Pedro Góes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ETAlertView : UIView

@property (strong, nonatomic) IBOutlet UIView *masterView;
@property (strong, nonatomic) IBOutlet UIView *box;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UIView *messageBox;
@property (strong, nonatomic) IBOutlet UITextView *mainMessage;
@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UIButton *rightButton;

@property (strong, nonatomic) void (^leftBlock)(void);
@property (strong, nonatomic) void (^rightBlock)(void);

- (id)initWithTitle:(NSString *)title message:(NSString *)message confirmationButtonTitle:(NSString *)confirmationButtonTitle;
- (id)initWithTitle:(NSString *)title message:(NSString *)message confirmationButtonTitle:(NSString *)confirmationButtonTitle confirmationBlock:(void (^)(void))confirmationBlock;
- (id)initWithTitle:(NSString *)title message:(NSString *)message negativeButtonTitle:(NSString *)negativeButtonTitle positiveButtonTitle:(NSString *)positiveButtonTitle;
- (id)initWithTitle:(NSString *)title message:(NSString *)message negativeButtonTitle:(NSString *)negativeButtonTitle positiveButtonTitle:(NSString *)positiveButtonTitle negativeBlock:(void (^)(void))negativeBlock positiveBlock:(void (^)(void))positiveBlock;

- (void)show;

@end
