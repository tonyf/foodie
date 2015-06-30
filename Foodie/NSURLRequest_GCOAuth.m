//
//  NSURLRequest_GCOAuth.m
//  Foodie
//
//  Created by Tony Francis on 6/30/15.
//  Copyright (c) 2015 Krishna Bharathala. All rights reserved.
//

#import "NSURLRequest_GCOAuth.h"
#import "GCOAuth.h"

static NSString * const kConsumerKey       = @"-Kz-oJQA9ckr6Bml2B_m-Q";
static NSString * const kConsumerSecret    = @"mlmMZA_BeyXY2jOakh_mfgkkV9Y";
static NSString * const kToken             = @"DFJVjfItJeFk361bhaarPdFz7qLsM2_d";
static NSString * const kTokenSecret       = @"i55norVbJcTb9HBHVw1nDDtL6o4";


@implementation NSURLRequest_GCOAuth

+ (NSURLRequest_GCOAuth *)requestWithHost:(NSString *)host path:(NSString *)path {
    return [self requestWithHost:host path:path params:nil];
}

+ (NSURLRequest_GCOAuth *)requestWithHost:(NSString *)host path:(NSString *)path params:(NSDictionary *)params {
    
    if ([kConsumerKey length] == 0 || [kConsumerSecret length] == 0 || [kToken length] == 0 || [kTokenSecret length] == 0) {
        NSLog(@"WARNING: Please enter your api v2 credentials before attempting any API request. You can do so in NSURLRequest+OAuth.m");
    }
    
    NSURLRequest_GCOAuth *request = [GCOAuth URLRequestForPath:path
                                         GETParameters:params
                                                  host:host
                                           consumerKey:kConsumerKey
                                        consumerSecret:kConsumerSecret
                                           accessToken:kToken
                                           tokenSecret:kTokenSecret];
    
    return request;
}

/**
 Builds an NSURL given a host, path and a number of queryParameters
 
 @param host The domain host of the API
 @param path The path of the API after the domain
 @param params The query parameters
 @return An NSURL built with the specified parameters
 */
+ (NSURL *)_URLWithHost:(NSString *)host path:(NSString *)path queryParameters:(NSDictionary *)queryParameters {
    
    NSMutableArray *queryParts = [[NSMutableArray alloc] init];
    for (NSString *key in [queryParameters allKeys]) {
        NSString *queryPart = [NSString stringWithFormat:@"%@=%@", key, queryParameters[key]];
        [queryParts addObject:queryPart];
    }
    
    NSURLComponents *components = [[NSURLComponents alloc] init];
    components.scheme = @"http";
    components.host = host;
    components.path = path;
    components.query = [queryParts componentsJoinedByString:@"&"];
    
    return [components URL];
}

@end
