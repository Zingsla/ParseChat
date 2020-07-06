//
//  ChatViewController.m
//  ParseChat
//
//  Created by Jacob Franz on 7/6/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatCell.h"
#import <Parse/Parse.h>

@interface ChatViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *chatMessageField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *array;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
}

- (IBAction)didTapSend:(id)sender {
    PFObject *chatMessage = [PFObject objectWithClassName:@"Message_fbu2020"];
    chatMessage[@"text"] = self.chatMessageField.text;
    [chatMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (succeeded) {
            NSLog(@"The message was saved!");
            self.chatMessageField.text = @"";
        } else {
            NSLog(@"Problem saving message: %@", error.localizedDescription);
        }
    }];
}

- (void)refresh {
    PFQuery *query = [PFQuery queryWithClassName:@"Message_fbu2020"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * posts, NSError * error) {
        if (posts != nil) {
            self.array = posts;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell"];
    PFObject *message = self.array[indexPath.row];
    cell.textLabel.text = message[@"text"];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
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
