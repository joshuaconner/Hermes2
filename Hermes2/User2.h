//
//  User.h
//  Hermes2
//
//  Created by Arthur Pang on 3/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <RestKit/CoreData.h>

@interface User : NSManagedObject
@property (nonatomic, retain) NSNumber *userID;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *balance;

+ (NSDictionary*)elementToPropertyMappings;
+ (NSString*)primaryKeyProperty;

@end
