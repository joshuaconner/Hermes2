//
//  SignUpViewController.m
//  Hermes2
//
//  Created by Arthur Pang on 3/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SignUpViewController.h"
#import "HermesViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController
@synthesize nameTextField;
@synthesize emailTextField;
@synthesize passwordTextField;

- (IBAction)createAccountButtonWasPressed:(id)sender{
    [self sendRequest];
}

- (void)sendRequest{
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    [objectManager loadObjectsAtResourcePath:@"/users" delegate:self block:^(RKObjectLoader* loader) {
        RKParams *params = [RKParams params];
        [params setValue:nameTextField.text forParam:@"user[name]"];
        [params setValue:emailTextField.text forParam:@"user[email]"];
        [params setValue:passwordTextField.text forParam:@"user[password]"];
        loader.params = params;
        loader.objectMapping = [objectManager.mappingProvider objectMappingForClass:[User class]];
        loader.method = RKRequestMethodPOST;
    }];
}

# pragma mark - TextField delegate methods
                         
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"textfield should return");
    if (textField == passwordTextField){
        [self sendRequest];
        [self.view endEditing:YES];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"textFieldDidEndEditing");
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)signInButtonWasPressed:(id)sender {
    NSLog(@"sign in button was pressed");
}

- (IBAction)signUpButtonWasPressed:(id)sender {
    NSLog(@"sign up button was pressed");
}

#pragma mark RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
	NSLog(@"Loaded objects: %@", objects);
    User *user = [objects objectAtIndex:0];
    NSLog(@"user email: %@", user.email);
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
	NSLog(@"Hit error: %@", error);
}

- (void)requestDidStartLoad:(RKRequest *)request{
    NSLog(@"R did start load");
}

- (void)requestDidCancelLoad:(RKRequest *)request{
    NSLog(@"R did cancel load");
}

- (void)requestDidTimeout:(RKRequest *)request{
    NSLog(@"R did timeout");
}

- (void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error {
    RKLogError(@"Load of RKRequest %@ failed with error: %@", request, error);
    NSLog(@"RK error");
}

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response {
    RKLogCritical(@"Loading of RKRequest %@ completed with status code %d. Response body: %@", request, response.statusCode, [response bodyAsString]);
    if (response.statusCode == 201) {
        HermesViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Main Menu"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}

- (void)request:(RKRequest *)request didReceiveData:(NSInteger)bytesReceived totalBytesReceived:(NSInteger)totalBytesReceived totalBytesExpectedToReceive:(NSInteger)totalBytesExpectedToReceive{
    NSLog(@"did get data");
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
