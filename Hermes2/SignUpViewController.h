//
//  SignUpViewController.h
//  Hermes2
//
//  Created by Arthur Pang on 3/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "User.h"

@interface SignUpViewController : UITableViewController <RKObjectLoaderDelegate, RKRequestDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)dismissKeyboard:(id)sender;
- (IBAction)createAccountButtonWasPressed:(id)sender;
- (void)sendRequest;

@end
