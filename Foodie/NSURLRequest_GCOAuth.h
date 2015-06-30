//
//  NSURLRequest_GCOAuth.h
//  Foodie
//
//  Created by Tony Francis on 6/30/15.
//  Copyright (c) 2015 Krishna Bharathala. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest_GCOAuth : NSObject

/**
 @param host The domain host
 @param path The path on the domain host
 @return Builds a NSURLRequest with all the OAuth headers field set with the host and path given to it.
 */
+ (NSURLRequest *)requestWithHost:(NSString *)host path:(NSString *)path;

/**
 @param host The domain host
 @param params The query parameters
 @return Builds a NSURLRequest with all the OAuth headers field set with the host, path, and query parameters given to it.
 */
+ (NSURLRequest *)requestWithHost:(NSString *)host path:(NSString *)path params:(NSDictionary *)params;

@end
