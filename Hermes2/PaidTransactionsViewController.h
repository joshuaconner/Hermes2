//
//  PaidTransactionsViewController.h
//  Hermes2
//
//  Created by Arthur Pang on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "PullToRefreshView.h"

@interface PaidTransactionsViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, RKObjectLoaderDelegate, PullToRefreshViewDelegate> {
    PullToRefreshView *pull;
    NSArray *paidTransactions;
}

@end
