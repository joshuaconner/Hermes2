//
//  SigninViewController.m
//  Hermes
//
//  Created by Arthur Pang on 2/19/12.
//  Copyright (c) 2012 Northern Arizona University. All rights reserved.
//

#import "SigninViewController.h"
#import "HermesViewController.h"
#import "MBProgressHUD.h"

@interface SigninViewController () <MBProgressHUDDelegate> 
@property (strong, nonatomic) MBProgressHUD *HUD;
@property (nonatomic) BOOL loginSuccess;
@property (nonatomic) BOOL checkboxIsChecked;
@end

@implementation SigninViewController
@synthesize checkboxIsChecked = _checkboxIsChecked;
@synthesize loginSuccess = _loginSuccess;
@synthesize emailTextField;
@synthesize passwordTextField;
@synthesize rememberMeButton;
@synthesize HUD = _HUD;

- (MBProgressHUD *)HUD {
    if (!_HUD) {
        _HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    }
    return _HUD;
}

- (void)viewDidLoad
{
    self.passwordTextField.delegate = self;
    self.loginSuccess = NO;
    self.checkboxIsChecked = YES;
}

- (void)viewDidUnload
{
    [self setEmailTextField:nil];
    [self setPasswordTextField:nil];
    [self setRememberMeButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"textfield should return");
    if (textField == passwordTextField){
        [self sendRequest];
        [self.passwordTextField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textFieldDidEndEditing");
}


- (IBAction)dismissKeyboard:(id)sender{
    [self.view endEditing:YES];
}

/**
 * Changes the state of the "remember me" checkbox when it's tapped
 */ 
- (IBAction)checkboxChecked {
    NSLog(@"Checkbox tapped!");
    self.checkboxIsChecked = !self.checkboxIsChecked;
    [self.rememberMeButton setSelected:self.checkboxIsChecked];
}

- (IBAction)showWithGradient {
	[self.navigationController.view addSubview:self.HUD];
	
	self.HUD.dimBackground = YES;
	
	// Regiser for HUD callbacks so we can remove it from the window at the right time
    self.HUD.delegate = self;
    
    self.HUD.labelText = @"Signing in...";
	
    // Show the HUD while the provided method executes in a new thread
    [self.HUD show:YES];
}

- (IBAction)sendRequest {
    RKParams* params = [RKParams params];
    [params setValue:emailTextField.text forParam:@"user[email]"];
    [params setValue:passwordTextField.text forParam:@"user[password]"];
    [[RKClient sharedClient] post:@"/users/sign_in.json" params:params delegate:self];
    [self showWithGradient];
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
        //HACK: we're receiving two identical responses and it's screwing stuff up, so we're only going act on the first one
        if (!self.loginSuccess) {
            self.loginSuccess = true;
            [self.HUD hide:YES];
            HermesViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Main Menu"];
            [self.navigationController pushViewController:controller animated:YES];
        }
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

#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [self.HUD removeFromSuperview];
	self.HUD = nil;
}

@end
