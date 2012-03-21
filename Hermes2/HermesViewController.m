//
//  HermesViewController.m
//  Hermes2
//
//  Created by Joshua Conner on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HermesViewController.h"
#import "ZBarSDK.h"
#import "HermesQuickPayController.h"

@interface HermesViewController () <ZBarReaderDelegate>
@property (strong, nonatomic) NSString *resultText;
@property (strong, nonatomic) UIImage *resultImage;
@end

@implementation HermesViewController
@synthesize resultText = _resultText;
@synthesize resultImage = _resultImage;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

/**
 * instantiate the QR reader!
 */
- (IBAction)quickPayButtonPressed {
    // ADD: present a barcode reader that scans from the camera feed
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    // present and release the controller
    [self presentModalViewController: reader
                            animated: YES];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue called!");
    if ([segue.destinationViewController respondsToSelector:@selector(setResultText:)]) {
        NSLog(@"Setting result text!");
        [segue.destinationViewController setResultText:self.resultText]; 
    }
    
    if ([segue.destinationViewController respondsToSelector:@selector(setResultImage:)]) {
        NSLog(@"Setting result image!");
        [segue.destinationViewController setResultImage:self.resultImage];
    }
}

#pragma mark ZBReaderViewControllerDelegate Methods
- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    NSLog(@"Results: %@", results);
    
    ZBarSymbol *symbol = nil;

    for(symbol in results) {
        self.resultText = symbol.data;
        break;
    }
    
    // EXAMPLE: do something useful with the barcode image
    self.resultImage =
    [info objectForKey: UIImagePickerControllerOriginalImage];
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissModalViewControllerAnimated: YES];
    
    [self performSegueWithIdentifier:@"QuickPaySegue" sender:self];
}
@end
