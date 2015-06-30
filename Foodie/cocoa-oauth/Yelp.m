//
//  Yelp.m
//  Foodie
//
//  Created by Krishna Bharathala on 6/29/15.
//  Copyright (c) 2015 Krishna Bharathala. All rights reserved.
//

#import "Yelp.h"

@implementation Yelp

- (id)initWithName: (NSString *)name
           address: (NSString *)address
       ratingImage: (NSString *) ratingImage
           cuisine: (NSString *) cuisine {
    
    self = [super init];
    
    if(self) {
        self.name = name;
        self.address = address;
        self.ratingImage = ratingImage;
        self.cuisine = cuisine;
    }
    return self;

}

@end
