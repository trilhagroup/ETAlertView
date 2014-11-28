ETAlertView
========
Sometimes Apple's stock UIAlertView doesn't give you enough flexibility to change some of its design, so **ETAlertView** is a simple popup that allows you to change anything you want.

Installation
--------
Clone this repo and copy the folder **ETAlertView** into your Xcode project.

How-to
--------

![image](demo.png)

### Programmatically

Programmatically, just use the following method:

```
[[ETAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Oh oh.. It appears that our server is having some trouble. Do you want to try again?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"No", nil) otherButtonTitle:NSLocalizedString(@"Yes", nil)];
```

And then show it onscreen:

```
[alertView show];
```

### Delegates

There are some delegates you can implement as callbacks:

```
- (void)alertView:(ETAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
```

### Getters

There are some properties you can have access to. Accessible at anytime, just KVO them. 

- `@property (strong, nonatomic) IBOutlet UIView *masterView;`
- `@property (strong, nonatomic) IBOutlet UIView *box;`
- `@property (strong, nonatomic) IBOutlet UILabel *title;`
- `@property (strong, nonatomic) IBOutlet UIView *messageBox;`
- `@property (strong, nonatomic) IBOutlet UIButton *message;`
- `@property (strong, nonatomic) IBOutlet UIButton *yesButton;`
- `@property (strong, nonatomic) IBOutlet UIButton *noButton;`
- `@property (assign, nonatomic) NSInteger errorCode;`

Support
--------
Just open an issue on Github and we'll get to it as soon as possible.

About
--------
**ETAlertView** is brought to you by Trilha.
