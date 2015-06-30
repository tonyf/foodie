//
//  GroupsTableViewController.h
//  Foodie
//
//  Created by Tony Francis on 6/29/15.
//  Copyright (c) 2015 Krishna Bharathala. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Firebase;
@class User;
@class Group;

@interface GroupsTableViewController : UITableViewController

@property (nonatomic, strong) User *currentUser;

@property (nonatomic, strong) NSMutableArray *userGroups;
@property (strong, nonatomic) Firebase *reference;

@property (strong, nonatomic) Group *selectedGroup;


@end
