//
//  YelpAPI.m
//  Foodie
//
//  Created by Krishna Bharathala on 6/29/15.
//  Copyright (c) 2015 Krishna Bharathala. All rights reserved.
//

#import "YelpAPI.h"
#import "GCOAuth.h"
#import "NSURLRequest_GCOAuth.h"
#import "Yelp.h"

static NSString * const kAPIHost           = @"api.yelp.com";
static NSString * const kSearchPath        = @"/v2/search/";
static NSString * const kBusinessPath      = @"/v2/business/";
static NSString * const kSearchLimit       = @"20";

@implementation YelpAPI

- (void)queryRandomBusinessInfoForTerm:(NSString *)term location:(NSString *)location completionHandler:(void (^)(Yelp *yp, NSError *error))completionHandler {
    
    NSLog(@"Querying the Search API with term \'%@\' and location \'%@'", term, location);
    
    //Make a first request to get the search results with the passed term and location
    NSURLRequest *searchRequest = [self _searchRequestWithTerm:term location:location];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:searchRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if (!error && httpResponse.statusCode == 200) {
            
            NSDictionary *searchResponseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSArray *businessArray = searchResponseJSON[@"businesses"];
            
            if ([businessArray count] > 0) {
                NSUInteger randomIndex = arc4random() % [businessArray count];
                NSDictionary *business = [businessArray objectAtIndex:randomIndex];
                NSString *businessID = business[@"id"];
                NSLog(@"%lu businesses found, querying business info for the random result: %@", (unsigned long)[businessArray count], businessID);
                
                [self queryBusinessInfoForBusinessId:businessID completionHandler:completionHandler];
                
            } else {
                completionHandler(nil, error); // No business was found
            }
        } else {
            completionHandler(nil, error); // An error happened or the HTTP response is not a 200 OK
        }
    }] resume];
}

- (void)queryBusinessInfoForBusinessId:(NSString *)businessID completionHandler:(void (^)(Yelp *yp, NSError *error))completionHandler {
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest_GCOAuth *businessInfoRequest = [self _businessInfoRequestForID:businessID];
    [[session dataTaskWithRequest:businessInfoRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (!error && httpResponse.statusCode == 200) {
            NSDictionary *businessResponseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            
            Yelp *yp = [[Yelp alloc] init];
            
            //NSLog(@"%@", businessResponseJSON);
            yp.name = businessResponseJSON[@"name"];
            yp.address = [NSString stringWithFormat:@"%@, %@",
                          [businessResponseJSON[@"location"][@"address"] objectAtIndex:0],
                          businessResponseJSON[@"location"][@"city"]];
            yp.ratingImage = businessResponseJSON[@"rating_img_url"];
            yp.cuisine = [[businessResponseJSON[@"categories"] objectAtIndex:0] objectAtIndex:0];
            
            completionHandler(yp, error);
            
        } else {
            completionHandler(nil, error);
        }
    }] resume];
    
}

#pragma mark - API Request Builders

/**
 Builds a request to hit the search endpoint with the given parameters.
 
 @param term The term of the search, e.g: dinner
 @param location The location request, e.g: San Francisco, CA
 
 @return The NSURLRequest_GCOAuth needed to perform the search
 */
- (NSURLRequest_GCOAuth *)_searchRequestWithTerm:(NSString *)term location:(NSString *)location {
    NSDictionary *params = @{
                             @"term": term,
                             @"location": location,
                             @"limit": kSearchLimit
                             };
    
    return [NSURLRequest_GCOAuth requestWithHost:kAPIHost path:kSearchPath params:params];
}

- (NSURLRequest_GCOAuth *)_businessInfoRequestForID:(NSString *)businessID {
    
    NSString *businessPath = [NSString stringWithFormat:@"%@%@", kBusinessPath, businessID];
    return [NSURLRequest_GCOAuth requestWithHost:kAPIHost path:businessPath];
}

@end
