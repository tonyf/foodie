//
//  MakeGroupTableViewController.m
//  Foodie
//
//  Created by Tony Francis on 6/30/15.
//  Copyright (c) 2015 Krishna Bharathala. All rights reserved.
//

#import "MakeGroupTableViewController.h"
#import <Firebase/Firebase.h>
#import "User.h"
#import "MessagingViewController.h"

@implementation MakeGroupTableViewController


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.reference = [[Firebase alloc] initWithUrl:@"https://foodie-app.firebaseio.com/users"];
        self.allUsers = [[NSMutableArray alloc] init];
        self.usersArray = [[NSMutableArray alloc] init];
        NSLog(@"here");
        [[self.reference queryOrderedByKey] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            
            NSLog(@"%@", snapshot);
            for (FDataSnapshot* child in snapshot.children) {
                User *thisUser = [[User alloc] init];
                thisUser.name = child.value[@"name"];
                thisUser.userId = child.value[@"fbID"];
                [self.allUsers addObject:thisUser];
            }
            
            
            NSLog(@"%@", self.allUsers);
            NSIndexPath *path = [NSIndexPath indexPathForRow:self.allUsers.count inSection:0];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:path];
            
            UIBarButtonItem *make = [[UIBarButtonItem alloc]
                                           initWithTitle:@"Make Group"
                                           style:UIBarButtonItemStyleBordered
                                           target:self
                                           action:@selector(createGroup)];
            self.navigationItem.rightBarButtonItem = make;
            
            [self reload];
        }];

    }
    return self;
}


- (void)reload {
    [self.tableView reloadData];
}


- (void)createGroup {
    Firebase *groups = [[Firebase alloc] initWithUrl:@"https://foodie-app.firebaseio.com/groups/"];
    Firebase *newGroup = [groups childByAutoId];
    [newGroup setValue:self.usersArray];
    [self.usersArray addObject:self.currentUser.userId];
    
    NSMutableArray *userKeys = [[NSMutableArray alloc] init];
    int i = 0;
    for (NSString *user in self.usersArray) {
        [userKeys addObject:[NSString stringWithFormat:@"%d", i ]];
        i++;
    }
    if (self.usersArray.count > 0 && userKeys.count > 0) {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjects:self.usersArray forKeys:userKeys];
        [newGroup updateChildValues:dict];
        NSLog(@"got here");
    }
    
    
    // Add the group to each user's list of groups
    for (NSString *userIdString in self.usersArray) {
        Firebase *userRef = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"https://foodie-app.firebaseio.com/users/facebook:%@/groups/", userIdString]];
        NSMutableDictionary *dictionary2 = [[NSMutableDictionary alloc] init];
        [dictionary2 setObject:newGroup.key forKey:@"0"];
        [userRef updateChildValues:dictionary2];
    }
    self.createdGroupId = newGroup.key;
    [self performSegueWithIdentifier:@"messageWithNew" sender:self];
    [self.tableView reloadData];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"messageWithNew"]) {
        MessagingViewController *mvc = (MessagingViewController *) [segue destinationViewController];
        mvc.senderUser = self.currentUser;
        
        mvc.groupId = self.createdGroupId;
        mvc.senderId = self.currentUser.userId;
        NSLog(@"FUCK");
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    User *userForCell = self.allUsers[indexPath.item];
    cell.textLabel.text = userForCell.name;
    NSLog(@"%@", userForCell.name);
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%lu", (unsigned long)[self.allUsers count]);
    return [self.allUsers count];
}

// Not sure which one to use for selection

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"alkjdflkjskldf");
    User *user = self.allUsers[indexPath.item];
    NSString *userId = user.userId;
    [self.usersArray addObject:userId];
    NSLog(@"%@", self.usersArray);
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    User *user = self.allUsers[indexPath.item];
    NSString *userId = user.userId;
    [self.usersArray removeObject:userId];
    
}

// or this

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    User *user = self.allUsers[indexPath.item];
    NSString *userId = user.userId;
    [self.usersArray addObject:userId];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    User *user = self.allUsers[indexPath.item];
    NSString *userId = user.userId;
    [self.usersArray removeObject:userId];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
