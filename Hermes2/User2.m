//
//  User.m
//  Hermes2
//
//  Created by Arthur Pang on 3/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "User.h"

@implementation User
@dynamic userID;
@dynamic email;
@dynamic password;
@dynamic name;
@dynamic balance;

+ (NSDictionary*)elementToPropertyMappings {
    return [NSDictionary dictionaryWithKeysAndObjects:
            @"id", @"userID",
            @"email", @"title",
            @"password", @"password",
            @"name", @"name",
            @"balance", @"balance",            
            nil];
}

+ (NSString*)primaryKeyProperty {
    return @"userID";
}

@end