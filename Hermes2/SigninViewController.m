//
//  SigninViewController.m
//  Hermes
//
//  Created by Arthur Pang on 2/19/12.
//  Copyright (c) 2012 Northern Arizona University. All rights reserved.
//

#import "SigninViewController.h"
#import "HermesViewController.h"
#import "User.h"
#import "SFHFKeychainUtils.h"
#import "MBProgressHUD.h"

@interface SigninViewController () <MBProgressHUDDelegate> 
@property (nonatomic) BOOL checkboxIsChecked;
@property (strong, nonatomic) MBProgressHUD *HUD;
@end

@implementation SigninViewController
@synthesize emailTextField;
@synthesize passwordTextField;
@synthesize rememberMeCheckbox = _rememberMeCheckbox;
@synthesize checkboxIsChecked = _checkboxIsChecked;
@synthesize HUD = _HUD;

- (MBProgressHUD *)HUD {
    if (!_HUD) {
        _HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    }
    return _HUD;
}


#define SERVICE_NAME @"HermesSimpleMoney"


/**
 * prepopulate username and password from keychain if possible
 */
- (void)viewDidLoad
{
    self.checkboxIsChecked = YES;
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *email = [defaults objectForKey:@"email"];
    NSString *password = [SFHFKeychainUtils getPasswordForUsername:email 
                                                    andServiceName:SERVICE_NAME 
                                                             error:nil];
    
    self.emailTextField.text = email;
    self.passwordTextField.text = password;
}

- (void)viewDidUnload
{
    [self setEmailTextField:nil];
    [self setPasswordTextField:nil];
    [self setRememberMeCheckbox:nil];

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/**
 * send request and end editing if exiting the passwordTextField
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == passwordTextField){
        [self sendRequest];
        [self.view endEditing:YES];
    } else {
        [textField resignFirstResponder];
        [passwordTextField becomeFirstResponder];
    }
    return YES;
}

/**
 * hides the keyboard when we tap away from it
 */
- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}


- (void)sendRequest {
    //pop up "signing in..." modal
    [self showWithGradient];
    
    //save username and password if needed
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (self.checkboxIsChecked) {
        //save values to keychain
        [defaults setObject:self.emailTextField.text forKey:@"email"];
        
        [SFHFKeychainUtils storeUsername:self.emailTextField.text
                             andPassword:self.passwordTextField.text
                          forServiceName:SERVICE_NAME 
                          updateExisting:YES 
                                   error:nil];
    } else {
        [defaults setObject:nil forKey:@"email"];
        [SFHFKeychainUtils deleteItemForUsername:self.emailTextField.text 
                                  andServiceName:SERVICE_NAME
                                           error:nil];

    }
    [defaults synchronize];
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager loadObjectsAtResourcePath:@"/users/sign_in" delegate:self block:^(RKObjectLoader* loader) {
        loader.objectMapping = [objectManager.mappingProvider objectMappingForClass:[User class]];
        RKParams *params = [RKParams params];
        [params setValue:emailTextField.text forParam:@"user[email]"];
        [params setValue:passwordTextField.text forParam:@"user[password]"];
        loader.params = params;
        [loader setMethod:RKRequestMethodPOST];
    }];
    
}

/**
 * toggles the "remember me?" checkbox when tapped
 */
- (IBAction)rememberMePressed {
    self.checkboxIsChecked = !self.checkboxIsChecked;
    [self.rememberMeCheckbox setSelected:self.checkboxIsChecked];
}

/**
 * sends login when "sign in" button pressed
 */
- (IBAction)signInButtonPressed {
    [self sendRequest];
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
    [self.HUD hide:YES];
}

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response {
    RKLogCritical(@"Loading of RKRequest %@ completed with status code %d. Response body: %@", request, response.statusCode, [response bodyAsString]);
    if (response.statusCode == 201) {
        [self.HUD hide:YES];
        HermesViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Main Menu"];
        [self.navigationController pushViewController:controller animated:YES];
        
    }
    
}

- (void)request:(RKRequest *)request didReceiveData:(NSInteger)bytesReceived totalBytesReceived:(NSInteger)totalBytesReceived totalBytesExpectedToReceive:(NSInteger)totalBytesExpectedToReceive{
    NSLog(@"did get data");
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark MBProgressHUD methods

- (IBAction)showWithGradient {
	[self.navigationController.view addSubview:self.HUD];
	
	self.HUD.dimBackground = YES;
	
	// Regiser for HUD callbacks so we can remove it from the window at the right time
    self.HUD.delegate = self;
    
    self.HUD.labelText = @"Signing in...";
	
    // Show the HUD while the provided method executes in a new thread
    [self.HUD show:YES];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [self.HUD removeFromSuperview];
	self.HUD = nil;
}

@end
