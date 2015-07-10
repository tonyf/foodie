//
//  SpexViewController.m
//  Foodie
//
//  Created by Sean Vasquez on 6/30/15.
//  Copyright (c) 2015 Krishna Bharathala. All rights reserved.
//

#import "SpexViewController.h"
#import "Yelp.h"
#import "YelpAPI.h"
#import "RandomRestaurantViewController.h"

@interface SpexViewController ()

@property (nonatomic) IBOutlet MKMapView *map;
@property (nonatomic) int loops;
@property (nonatomic) CLLocation *userLocation;
@property (nonatomic, strong) NSString *location;

@end

@implementation SpexViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        CLLocationManager *locManager = [[CLLocationManager alloc] init];
        [locManager requestWhenInUseAuthorization];
        [locManager startUpdatingLocation];
    }
    return self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.navigationItem.title = @"";
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    UIBarButtonItem *barButtonAppearance = [UIBarButtonItem appearance];
    [barButtonAppearance setTintColor:[UIColor whiteColor]];
    
    RandomRestaurantViewController *destVC = segue.destinationViewController;
    self.map.showsUserLocation = NO;
    
    NSString *term = @"dinner";
    NSString *location = self.location;
    
    
    if ([segue.identifier isEqualToString:@"yelpSegue"]) {
        //self.navigationController.topViewController = destVC;
        destVC.groupID = self.groupID;
        YelpAPI *API = [[YelpAPI alloc] init];
        dispatch_group_t requestGroup = dispatch_group_create();
        
        dispatch_group_enter(requestGroup);
        [API queryRandomBusinessInfoForTerm:term location:location completionHandler:^(Yelp *yp, NSError *error) {
            
            if (error) {
                NSLog(@"An error happened during the request: %@", error);
            } else if (yp) {
                destVC.address = yp.address;
                destVC.name = yp.name;
                destVC.ratingImage = yp.ratingImage;
                destVC.userLocation = self.userLocation;
                destVC.cuisine = yp.cuisine;

                
            } else {
                NSLog(@"No business was found");
            }
            dispatch_group_leave(requestGroup);
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.map.showsUserLocation = YES;
    self.map.delegate = self;

    self.loops = 0;
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if(self.loops >= 2) {
        return;
    }

    self.userLocation = self.map.userLocation.location;
    MKCoordinateRegion mapRegion;
    mapRegion.center = self.userLocation.coordinate;
    mapRegion.span = MKCoordinateSpanMake(.2, .2);
    [self.map setRegion: mapRegion animated: YES];
    [self getCity];
    
    self.loops++;
    
}

-(void) getCity {
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    
    [ceo reverseGeocodeLocation: self.userLocation completionHandler:^(NSArray *placemarks, NSError *error) {
                  
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
                  
        self.location = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
    }];
}

@end
