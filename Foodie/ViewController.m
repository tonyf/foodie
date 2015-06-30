//
//  ViewController.m
//  Foodie
//
//  Created by Krishna Bharathala on 6/26/15.
//  Copyright (c) 2015 Krishna Bharathala. All rights reserved.
//

#import "ViewController.h"
#include <stdlib.h>

@interface ViewController ()

@property (strong, nonatomic) CLPlacemark *placemark;

@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager requestWhenInUseAuthorization];
    }
    return self;
}

- (void)viewDidLoad {
    self.mapView.delegate = self;
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 20;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    
    [self.locationManager startUpdatingLocation];
}



- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.currentLocation = locations.lastObject;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
         if (placemarks) {
             
             self.placemark = [placemarks objectAtIndex:0];
             self.address = self.placemark.locality;
             
             [self updateLabels];
         } else {
             NSLog(@"Geocode failed with error %@", error);
             NSLog(@"\nCurrent Location Not Detected\n");
             //return;
         }
     }];

    return;
}

-(void) updateLabels {
    
    self.nameLabel.text = [self.placemark.addressDictionary valueForKey:@"Name"];
    self.addressLabel.text = self.address;
    self.rating = arc4random_uniform(5);
    self.ratingLabel.text = [NSString stringWithFormat:@"%d", self.rating];
}



- (IBAction)getRandom:(id)sender {
    self.rating = arc4random_uniform(5)+1;
    self.ratingLabel.text = [NSString stringWithFormat:@"%d", self.rating];

}




@end
