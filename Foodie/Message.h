//
//  Message.h
//  Foodie
//
//  Created by Tony Francis on 6/29/15.
//  Copyright (c) 2015 Krishna Bharathala. All rights reserved.
//

#import "JSQMessageData.h"

@interface Message : NSObject <JSQMessageData>

@property (nonatomic, copy) NSString *senderId;
@property (nonatomic, copy) NSString *senderDisplayName;

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *imageUrl;
@property (strong, nonatomic) NSDate *date;

@property (nonatomic) BOOL isMediaMessage;
@property NSUInteger *messageHash;
@property id<JSQMessageMediaData> media;


@end
