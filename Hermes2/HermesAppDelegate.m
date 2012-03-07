//
//  HermesAppDelegate.m
//  Hermes2
//
//  Created by Joshua Conner on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HermesAppDelegate.h"
#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>
#import "User.h"
#import "Transaction.h"

@implementation HermesAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    RKLogConfigureByName("RestKit/Network*", RKLogLevelTrace);
    // Initialize RestKit
	RKObjectManager* objectManager = [RKObjectManager objectManagerWithBaseURL:@"http://severe-leaf-6733.herokuapp.com/"];
    // Enable automatic network activity indicator management
    objectManager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    
    NSString *databaseName = @"SimpleMoney.sqlite";
    objectManager.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:databaseName];
    
    // Setup our object mappings
    // Here we are targetting a Core Data entity with a specific name.
    // This allows us to map back HCI user objects directly onto NSManagedObject instances
    
    /*
    RKManagedObjectMapping *userMapping = [RKManagedObjectMapping mappingForEntityWithName:@"User"];
    userMapping.primaryKeyAttribute = @"userID";
    [userMapping mapKeyPath:@"id" toAttribute:@"userID"];
    [userMapping mapKeyPath:@"email" toAttribute:@"email"];
    [userMapping mapKeyPath:@"password" toAttribute:@"password"];
    [userMapping mapKeyPath:@"name" toAttribute:@"name"];
    [userMapping mapKeyPath:@"balance" toAttribute:@"balance"];
     */
    
    
    RKObjectMapping* userMapping = [RKObjectMapping mappingForClass:[User class]];
    [userMapping mapKeyPath:@"id" toAttribute:@"userID"];
    [userMapping mapKeyPath:@"email" toAttribute:@"email"];
    [userMapping mapKeyPath:@"password" toAttribute:@"password"];
    [userMapping mapKeyPath:@"name" toAttribute:@"name"];
    [userMapping mapKeyPath:@"balance" toAttribute:@"balance"];
    
    
    // This maps User model attributes to JSON params that our rails server understands.
    RKObjectMapping* userSerializationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]]; 
    [userSerializationMapping mapKeyPath:@"userID" toAttribute:@"user[id]"];
    [userSerializationMapping mapKeyPath:@"email" toAttribute:@"user[email]"];
    [userSerializationMapping mapKeyPath:@"password" toAttribute:@"user[password]"];
    [userSerializationMapping mapKeyPath:@"name" toAttribute:@"user[name]"];
    [userSerializationMapping mapKeyPath:@"balance" toAttribute:@"user[balance]"];
    
    /*
    RKManagedObjectMapping* transactionMapping = [RKManagedObjectMapping mappingForClass:[Transaction class]];
    transactionMapping.primaryKeyAttribute = @"transactionID";
    [transactionMapping mapKeyPathsToAttributes:@"id", @"transactionID",
     @"amount", @"amount",
     @"sender_id", @"sender_id",
     @"recipient_id", @"recipient_id",
     @"complete", @"complete",
     @"description", @"transactionDescription",
     @"created_at", @"created_at",
     @"updated_at", @"updated_at",
     nil];
    [transactionMapping mapRelationship:@"user" withMapping:userMapping];
    */
    
    RKObjectMapping* transactionMapping = [RKObjectMapping mappingForClass:[Transaction class]];
    [transactionMapping mapKeyPath:@"id" toAttribute:@"transactionID"];
    [transactionMapping mapKeyPath:@"amount" toAttribute:@"amount"];
    [transactionMapping mapKeyPath:@"sender_id" toAttribute:@"sender_id"];
    [transactionMapping mapKeyPath:@"recipient_id" toAttribute:@"recipient_id"];
    [transactionMapping mapKeyPath:@"complete" toAttribute:@"complete"];
    [transactionMapping mapKeyPath:@"description" toAttribute:@"transactionDescription"];
    [transactionMapping mapKeyPath:@"created_at" toAttribute:@"created_at"];
    [transactionMapping mapKeyPath:@"updated_at" toAttribute:@"updated_at"];

    
    // Setup date format so our timestamps get converted into NSDate objects.
    [RKObjectMapping addDefaultDateFormatterForString:@"E MMM d HH:mm:ss Z y" inTimeZone:nil];
    
    // Register our mappings with the provider.
    [objectManager.mappingProvider setMapping:userMapping forKeyPath:@"user"];
    [objectManager.mappingProvider setSerializationMapping:userSerializationMapping forClass:[User class]];
    [objectManager.mappingProvider setMapping:transactionMapping forKeyPath:@"transaction"];
    [objectManager.router routeClass:[User class] toResourcePath:@"/users/"];

    
    

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
