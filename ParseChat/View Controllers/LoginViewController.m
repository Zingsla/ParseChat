//
//  LoginViewController.m
//  ParseChat
//
//  Created by Jacob Franz on 7/6/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didTapSignup:(id)sender {
    PFUser *newUser = [PFUser user];
    
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error != nil) {
            [self testLogin];
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"User registered successfully!");
        }
    }];
}

- (IBAction)didTapLogin:(id)sender {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError * error) {
        if (error != nil) {
            [self testLogin];
            NSLog(@"User log in failed: %@", error);
        } else {
            NSLog(@"User logged in successfully!");
        }
    }];
}

- (void)testLogin {
    UIAlertController *alert;
    
    if ([self.usernameField.text isEqualToString:@""] || [self.passwordField.text isEqualToString:@""]) {
        alert = [UIAlertController alertControllerWithTitle:@"Invalid username or password" message:@"Please check to make sure that you entered a username and password and try again" preferredStyle:UIAlertControllerStyleAlert];
    } else {
        alert = [UIAlertController alertControllerWithTitle:@"Login Error" message:@"Please check to make sure that your username and password are correct and try again" preferredStyle:UIAlertControllerStyleAlert];
    }
    
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:dismissAction];
    [self presentViewController:alert animated:YES completion:^{
    }];
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
