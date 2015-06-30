//
//  LoginViewController.m
//  Foodie
//
//  Created by Sam Lim-Kimberg on 6/29/15.
//  Copyright (c) 2015 Krishna Bharathala. All rights reserved.
//

#import "LoginViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Firebase/Firebase.h>
#import "User.h"
#import "GroupsTableViewController.h"

@interface LoginViewController ()
@property (strong, nonatomic) Firebase* ref;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    self.currentUser = [[User alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)saveUser:(FAuthData *)authData{
    //fetching user name

}
- (IBAction)loginPressed:(id)sender {
    [self authenticateUser];
}

-(void)authenticateUser{
    //get a reference to user database
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://foodie-app.firebaseio.com"];
    
    //login to fb
    FBSDKLoginManager *facebookLogin = [[FBSDKLoginManager alloc] init];
    
    [facebookLogin logInWithReadPermissions:@[@"email"]
        handler:^(FBSDKLoginManagerLoginResult *facebookResult, NSError *facebookError) {

        if (facebookError) {
            NSLog(@"Facebook login failed. Error: %@", facebookError);
        } else if (facebookResult.isCancelled) {
            NSLog(@"Facebook login got cancelled.");
        } else {
            NSString *accessToken = [[FBSDKAccessToken currentAccessToken] tokenString];

            [ref authWithOAuthProvider:@"facebook" token:accessToken
                withCompletionBlock:^(NSError *error, FAuthData *authData) {
                
            if (error) {
                NSLog(@"Login failed. %@", error);
            } else {
                NSLog(@"Logged in! %@", authData);
            }
                    //I used childByAutoId and kept the original fb user ID
                    //just in case : - )
                    NSString *userName = authData.providerData[@"displayName"];
                    NSString *userID = authData.providerData[@"id"];
                    NSDictionary *user = @{
                                           @"name" : userName,
                                           @"fbID" : userID
                                           };
                    Firebase *usersRef = [self.ref childByAppendingPath:@"users"];
                    Firebase *userPath = [usersRef childByAppendingPath:[NSString stringWithFormat:@"%@", [authData uid]]];
                    Firebase *thePath = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"https://foodie-app.firebaseio.com/users/%@", [authData uid]]];
                    
                    
                    [thePath updateChildValues:user];
                    
                    self.currentUser.userId = userID;
                    self.currentUser.name = userName;
                    
                    [self performSegueWithIdentifier:@"loginCompleteSegue" sender:self];
            
             }];
            
        }
        }];
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"loginCompleteSegue"]) {
        UINavigationController *nav = (UINavigationController *) [segue destinationViewController];
        GroupsTableViewController *gvc = (GroupsTableViewController *) nav.viewControllers[0];
        gvc.currentUser = self.currentUser;
    }
}

@end
