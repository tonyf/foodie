//
//  Yelp.h
//  Foodie
//
//  Created by Krishna Bharathala on 6/29/15.
//  Copyright (c) 2015 Krishna Bharathala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Yelp : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *ratingImage;
@property (strong, nonatomic) NSString *cuisine;

- (id)initWithName: (NSString *) name
           address: (NSString *) address
       ratingImage: (NSString *) ratingImage
           cuisine: (NSString *) cuisine;

@end
