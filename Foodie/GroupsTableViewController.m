//
//  GroupsTableViewController.m
//  Foodie
//
//  Created by Tony Francis on 6/29/15.
//  Copyright (c) 2015 Krishna Bharathala. All rights reserved.
//

#import "GroupsTableViewController.h"
#import <Firebase/Firebase.h>
#import "MessagingViewController.h"
#import "MakeGroupTableViewController.h"
#import "User.h"
#import "Group.h"

@implementation GroupsTableViewController


- (void)viewDidLoad {
    self.reference = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"https://foodie-app.firebaseio.com/users/facebook:%@/groups/", self.currentUser.userId]];
    // replace this
    
    NSLog(@"%@", self.currentUser.userId);
    self.userGroups = [[NSMutableArray alloc] init];
    [self getUserGroups];
    
}

- (void)getUserGroups {
    
    
    [self.reference observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"%@", snapshot);
        
        for (FDataSnapshot *child in snapshot.children) {
            Group *thisGroup = [[Group alloc] init];
            thisGroup.groupID = child.value;
            thisGroup.name = @"Group 1";
            [self.userGroups addObject:thisGroup];
        }
        NSLog(@"%d", (int) self.userGroups.count);
        [self.tableView reloadData];
    }];
    
//    [self.reference observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
//        self.userGroups = [snapshot value];
//        NSLog(@"%@", snapshot);
//        for(FDataSnapshot* child in snapshot.children){
//            Group *thisGroup = [[Group alloc]init];
//            thisGroup = child.value;
//            thisGroup.name = @"Group";
//            [self.userGroups addObject:thisGroup];
//        }
//    }];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    Group *groupForCell = self.userGroups[indexPath.item];
    cell.textLabel.text = groupForCell.name;
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.userGroups count];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"make"]) {
        MakeGroupTableViewController *mgvc = (MakeGroupTableViewController *) [segue destinationViewController];
        mgvc.currentUser = [self currentUser];
    }
    if ([segue.identifier isEqualToString:@"groupMessageShow"]) {
        MessagingViewController *mvc = (MessagingViewController *) [segue destinationViewController];
        mvc.groupId = self.selectedGroup.groupID;
        mvc.senderUser = [self currentUser];
        mvc.senderId = [[self currentUser] userId];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedGroup = self.userGroups[indexPath.item];
    
    [self performSegueWithIdentifier:@"groupMessageShow" sender:self];
}




@end
