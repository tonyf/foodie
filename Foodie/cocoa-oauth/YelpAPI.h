//
//  YelpAPI.h
//  Foodie
//
//  Created by Krishna Bharathala on 6/29/15.
//  Copyright (c) 2015 Krishna Bharathala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Yelp.h"

@interface YelpAPI : NSObject

- (void)queryRandomBusinessInfoForTerm:(NSString *)term location:(NSString *)location completionHandler:(void (^)(Yelp *yp, NSError *error))completionHandler;


@end
