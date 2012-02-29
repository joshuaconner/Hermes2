//
//  HermesLocalDealsViewController.m
//  Hermes2
//
//  Created by Joshua Conner on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HermesLocalDealsViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface HermesLocalDealsViewController () <CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) NSTimer *locationTimer;
@end

@implementation HermesLocalDealsViewController
@synthesize label;
@synthesize map = _map;
@synthesize locationManager = _locationManager;
@synthesize currentLocation = _currentLocation;
@synthesize locationTimer = _locationTimer;
#define LOCATION_TIMEOUT 30.0


// code from: http://www.iosdevnotes.com/2011/10/ios-corelocation-tutorial/

/**
 * Updates the device's location. If accurate enough (to 100m), stops updating the device's location.
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.currentLocation = newLocation;
    self.label.text = [NSString stringWithFormat:@"latitude %+.6f, longitude %+.6f\n",
                       newLocation.coordinate.latitude,
                       newLocation.coordinate.longitude];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 300, 300);
    MKCoordinateRegion adjustedRegion = [self.map regionThatFits:viewRegion];
    
    [self.map setRegion:adjustedRegion animated:YES];
}

/**
 * Pops up an alert error when the user denies location access to the app.
 */
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if(error.code == kCLErrorDenied) {
        [self.locationManager stopUpdatingLocation];
    } else if(error.code == kCLErrorLocationUnknown) {
        // retry
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error retrieving location"
                                                        message:[error description]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

/**
 * Stops attempting to update the device's location. Called when locationTimer expires before the device gets a good enough fix.
 */
- (void)stopUpdatingLocations 
{ 
    [self.locationManager stopUpdatingLocation]; 
    [self.locationTimer invalidate]; 
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)startStandardUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (nil == self.locationManager)
        self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    // Set a movement threshold for new events.
    self.locationManager.distanceFilter = 100;
    
    [self.locationManager startUpdatingLocation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if ([CLLocationManager locationServicesEnabled]) {
        self.label.text = @"Location enabled!";
        [self startStandardUpdates];

        //stop updating the location if we don't get a good enough fix after LOCATION_TIMEOUT seconds so we don't drain the battery.
        self.locationTimer = [NSTimer scheduledTimerWithTimeInterval:LOCATION_TIMEOUT target:self selector:@selector(stopUpdatingLocations) userInfo:nil repeats:NO];
        self.map.showsUserLocation = YES;
    }
}

- (void)viewDidUnload
{
    [self setLabel:nil];
    [self.locationManager stopUpdatingLocation];
    [self.locationTimer invalidate];
    [self setMap:nil];
    [self setMap:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
