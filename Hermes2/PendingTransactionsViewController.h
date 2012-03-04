//
//  PendingTransactionsViewController.h
//  Hermes2
//
//  Created by Arthur Pang on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface PendingTransactionsViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, RKObjectLoaderDelegate> {
    NSArray *pendingTransactions;
}

- (void)loadObjectsFromDataStore;

@end
