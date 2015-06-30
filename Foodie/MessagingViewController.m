//
//  MessagingViewController.m
//  Foodie
//
//  Created by Tony Francis on 6/29/15.
//  Copyright (c) 2015 Krishna Bharathala. All rights reserved.
//

#import "MessagingViewController.h"
#import "JSQMessagesViewController.h"
#import <Firebase/Firebase.h>
#import "JSQMessages.h"
#import "JSQMessagesAvatarImageFactory.h"
#import "JSQMessagesCollectionViewCell.h"
#import "Message.h"
#import "SpexViewController.h"
#import "User.h"

#define FIREBASE_URL @"https://foodie-app.firebaseio.com"

@implementation MessagingViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {

        // At this point, fuck security.
        
        // Set sender as user's id
    }
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.collectionView.collectionViewLayout.springinessEnabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.messagesReference) {
        [self.messagesReference unauth];
    }
}

// MARK: - Firebase Setup

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.messages = [[NSMutableArray alloc] init];
    self.senderId = self.senderUser.userId;
    self.senderDisplayName = self.senderUser.name;
    
    
    // set path to the firebase chat of the group
    self.messagesReference = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"https://foodie-app.firebaseio.com/groups/%@/messages", self.groupId]];
    
    self.inputToolbar.contentView.leftBarButtonItem = nil;
    self.automaticallyScrollsToMostRecentMessage = YES;
    
    [self setupFireBase];

}

- (void)setupFireBase {
    [[self.messagesReference queryLimitedToLast:30] observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        NSString *text = (NSString *) snapshot.value[@"text"];
        NSString *senderId = (NSString *) snapshot.value[@"senderId"];
        NSString *imageUrl = (NSString *) snapshot.value[@"imageUrl"];
        
        Message *message = [[Message alloc] init];
        message.text = text;
        message.senderId = senderId;
        message.imageUrl = imageUrl;
        
        [self.messages addObject:message];
        [self finishReceivingMessage];
    }];
}

- (void)sendMessage:(NSString *)text sender:(NSString *)sender {
    //    NSMutableDictionary *messageDict = [[NSMutableDictionary alloc] init];
    //
    //    messageDict[@"senderId"] = self.senderUser.userId;
    //    [messageDict setValue:text forKey:@"text"];
    //    [self.messagesReference updateChildValues:messageDict];
    //
    [[self.messagesReference childByAutoId] setValue:(@{@"text" : text,
                                                        @"senderId" : self.senderUser.userId})];
    
//    [self tempSendMessage:text sender:sender];
    [self finishSendingMessage];
}

- (void) tempSendMessage:(NSString *)text sender:(NSString *)sender {
    Message *message = [[Message alloc] init];
    message.senderId = sender;
    message.text = text;
    
    [self.messages addObject:message];
}

- (void)setupAvatarColorWithName:(NSString *)name incoming:(BOOL) incoming {
    CGFloat diameter = incoming ? self.collectionView.collectionViewLayout.incomingAvatarViewSize.width : self.collectionView.collectionViewLayout.outgoingAvatarViewSize.width;
    
    NSUInteger rgbValue = name.hash;
    CGFloat r = ((rgbValue & 0xFF0000) >> 16)/255.0;
    CGFloat g = ((rgbValue & 0xFF00) >> 8)/255.0;
    CGFloat b = ((rgbValue & 0xFF)/255.0);
    
    UIColor *color = [[UIColor alloc] initWithRed:r green:g blue:b alpha:0.5];
    
    NSArray *arr = [name componentsSeparatedByString:@" "];
    NSString *initials = [NSString stringWithFormat:@"%@ %@.", [arr objectAtIndex:0], [[arr objectAtIndex:1] substringToIndex:1]];
    
    JSQMessagesAvatarImage *image = [JSQMessagesAvatarImageFactory avatarImageWithUserInitials:initials backgroundColor:color textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:13] diameter:diameter];
    
    self.avatars[name] = image;
}

// MARK: - Actions

- (void)receivedMessagePressed:(UIBarButtonItem *)sender {
    self.showTypingIndicator = !(self.showTypingIndicator);
    [self scrollToBottomAnimated:YES];
}

- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date {
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    [self sendMessage:text sender:senderId];
    
    [self finishSendingMessage];
}

- (void)didPressAccessoryButton:(UIButton *)sender {
    NSLog(@"Camera Pressed!");
}

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.messages[indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Message *message = self.messages[indexPath.item];
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    
    JSQMessagesBubbleImage *outgoing = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleBlueColor]];
    JSQMessagesBubbleImage *incoming = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return outgoing;
    }
    return incoming;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessagesCollectionViewCell *messageCell = (JSQMessagesCollectionViewCell *) [super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    Message *message = self.messages[indexPath.item];
    NSDictionary *attributes = [[NSDictionary alloc] init];
    if ([message.senderId isEqualToString:self.senderId]) {
        messageCell.textView.textColor = [UIColor whiteColor];
    } else {
        messageCell.textView.textColor = [UIColor blackColor];
    }
    return messageCell;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    Message *message = self.messages[indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return (CGFloat) 0.0;
    }
    
    if (indexPath.item > 0) {
        Message *previousMessage = self.messages[indexPath.item - 1];
        if ([previousMessage.senderId isEqualToString:message.senderId]) {
            return (CGFloat) 0.0;
        }
    }
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"openRestNav"]) {
        UINavigationController *nav = (UINavigationController *) [segue destinationViewController];
        SpexViewController *spex = (SpexViewController *) nav.viewControllers[0];
        spex.groupID = self.groupId;
    }
    
}

@end
