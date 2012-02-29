//
//  HermesLocalDealsViewController.h
//  Hermes2
//
//  Created by Joshua Conner on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface HermesLocalDealsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet MKMapView *map;

@end
