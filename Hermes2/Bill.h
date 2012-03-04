//
//  Bill.h
//  Hermes2
//
//  Created by Arthur Pang on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <RestKit/CoreData.h>

@interface Bill : NSManagedObject

@property (nonatomic, retain) NSNumber * transaction_id;
@property (nonatomic, retain) NSDecimalNumber * amount;
@property (nonatomic, retain) NSNumber * sender_id;
@property (nonatomic, retain) NSNumber * recipient_id;
@property (nonatomic, retain) NSNumber * complete;
@property (nonatomic, retain) NSString * transactionDescription;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSDate * updated_at;

@end
