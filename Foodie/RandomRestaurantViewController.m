//
//  RandomRestaurantViewController.m
//  Foodie
//
//  Created by Sean Vasquez on 6/29/15.
//  Copyright (c) 2015 Krishna Bharathala. All rights reserved.
//

#import "RandomRestaurantViewController.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Yelp.h"
#import "YelpAPI.h"
#import <Firebase/Firebase.h>


@interface RandomRestaurantViewController ()


@property (nonatomic) IBOutlet UITextView *descriptionView;
@property (nonatomic) IBOutlet MKMapView *map;
@property (nonatomic) IBOutlet UITextView *cuisineType;


@end

@implementation RandomRestaurantViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    while(!self.ready) {
        sleep(0.1);
    }
    
    NSLog(@"%d", self.hasResults);
    
    if(!self.hasResults) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Results Found"
                                                        message:@"Please try again."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }

    self.navigationItem.title = self.name;
    self.descriptionView.text = self.address;
    self.cuisineType.text = self.cuisine;
    
    NSString *imageURL = self.ratingImage;
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
    self.ratingImageView.image = [UIImage imageWithData:imageData];
    
    
    //self.descriptionView.text self.details;
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:self.address completionHandler:^(NSArray *placemarks, NSError *error) {
        if([placemarks count]) {
            
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            CLLocation *location = placemark.location;
            self.coordinate = location.coordinate;
            
            
            CGFloat deltaLat = fabs(self.userLocation.coordinate.latitude - location.coordinate.latitude);
            CGFloat deltaLong = fabs(self.userLocation.coordinate.longitude - location.coordinate.longitude);
            
            CGFloat avgLat = (self.userLocation.coordinate.latitude + location.coordinate.latitude)/2.0;
            CGFloat avgLong = (self.userLocation.coordinate.longitude + location.coordinate.longitude)/2.0;
            
            MKCoordinateRegion mapRegion;
            mapRegion.center.latitude = avgLat;
            mapRegion.center.longitude = avgLong;
            mapRegion.span = MKCoordinateSpanMake(2*deltaLat, 2*deltaLong);
            [self.map setRegion: mapRegion animated: YES];
            
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            [annotation setCoordinate:self.coordinate];
            [self.map addAnnotation:annotation];

        } else {
            NSLog(@"location error");
            return;
        }
    }];
}

- (IBAction)getDirections:(id)sender {
    MKPlacemark* place = [[MKPlacemark alloc] initWithCoordinate: self.coordinate addressDictionary: nil];
    MKMapItem* destination = [[MKMapItem alloc] initWithPlacemark: place];
    destination.name = self.name;
    NSArray* items = [[NSArray alloc] initWithObjects: destination, nil];
    NSDictionary* options = [[NSDictionary alloc] initWithObjectsAndKeys:
                             MKLaunchOptionsDirectionsModeDriving,
                             MKLaunchOptionsDirectionsModeKey, nil];
    [MKMapItem openMapsWithItems: items launchOptions: options];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveButtonPressed:(id)sender {
    //[self saveRest];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveRest {
    Firebase *ref = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"https://foodie-app.firebaseio.com/groups/%@", self.groupID]];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
