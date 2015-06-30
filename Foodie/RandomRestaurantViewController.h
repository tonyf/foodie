//
//  RandomRestaurantViewController.h
//  Foodie
//
//  Created by Sean Vasquez on 6/29/15.
//  Copyright (c) 2015 Krishna Bharathala. All rights reserved.
//

#import "ModalTableViewController.h"
#import <MapKit/MapKit.h>
#import "Yelp.h"

@interface RandomRestaurantViewController : ModalTableViewController

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *ratingImage;
@property (nonatomic) NSString *details;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView;
@property (nonatomic) CLLocation *userLocation;
@property (nonatomic, strong) NSString *cuisine;
@end
