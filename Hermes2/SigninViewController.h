//
//  SigninViewController.h
//  Hermes
//
//  Created by Arthur Pang on 2/19/12.
//  Copyright (c) 2012 Northern Arizona University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface SigninViewController : UITableViewController <RKRequestDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *rememberMeButton;

- (IBAction)dismissKeyboard:(id)sender;
- (IBAction)checkboxChecked;


- (IBAction)sendRequest;

@end
