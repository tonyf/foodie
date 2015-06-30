//
//  SpexViewController.h
//  Foodie
//
//  Created by Sean Vasquez on 6/30/15.
//  Copyright (c) 2015 Krishna Bharathala. All rights reserved.
//

#import "ModalTableViewController.h"
#import "MapKit/MapKit.h"

@interface SpexViewController : ModalTableViewController <MKMapViewDelegate>

@property (nonatomic, strong) NSString *groupID;

@end
