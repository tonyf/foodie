//
//  MessagingViewController.h
//  Foodie
//
//  Created by Tony Francis on 6/29/15.
//  Copyright (c) 2015 Krishna Bharathala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSQMessagesViewController.h"
#import "Message.h"
@class Firebase;
@class User;

@interface MessagingViewController : JSQMessagesViewController

@property (strong, nonatomic) Firebase *messagesReference;
@property (nonatomic) NSString *groupId;
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) User *senderUser;

@property (strong, nonatomic) NSMutableDictionary *avatars;


- (void) tempSendMessage:(NSString *)text sender:(NSString *)sender;

@end
