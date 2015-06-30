//
//  Group.h
//  Foodie
//
//  Created by Sam Lim-Kimberg on 6/30/15.
//  Copyright (c) 2015 Krishna Bharathala. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Group : NSObject
@property (strong, nonatomic) NSMutableArray *usersInGroup;
@property (strong, nonatomic) NSString *groupID;
@property (strong, nonatomic) NSString *name;
@end
