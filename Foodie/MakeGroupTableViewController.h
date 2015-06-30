//
//  MakeGroupTableViewController.h
//  Foodie
//
//  Created by Tony Francis on 6/30/15.
//  Copyright (c) 2015 Krishna Bharathala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>
@class User;

@interface MakeGroupTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) Firebase *reference;
@property (nonatomic, strong) NSMutableArray *usersArray;

@property (nonatomic, strong) NSMutableArray *allUsers;
@property (nonatomic, strong) User *currentUser;

@property (nonatomic, strong) NSString *createdGroupId;

- (NSString *)createGroupWithUsers;

@end
