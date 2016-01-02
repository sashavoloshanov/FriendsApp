//
//  FriendsTableViewController.m
//  FriendsssssApp
//
//  Created by Voloshanov Sasha on 1/2/16.
//  Copyright © 2016 Sasha Voloshanov. All rights reserved.
//

#import "FriendsTableViewController.h"
#import "FriendTableViewCell.h"
#import "Friend.h"

@interface FriendsTableViewController ()

@property (strong, nonatomic) NSMutableArray *friendsArray;
@property (strong, nonatomic) UIActivityIndicatorView *romashka;

@end

@implementation FriendsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self performSelectorInBackground:@selector(fetchDataFromServer) withObject:nil];
    
    _romashka = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _romashka.center = self.view.center;
    _romashka.hidesWhenStopped = YES;
    [self.tableView addSubview:_romashka];
    [self.tableView bringSubviewToFront:_romashka];
    
}

- (void)fetchDataFromServer {
    [_romashka startAnimating];
    
    NSString *urlString = @"https://dl.dropboxusercontent.com/s/sf4bea5qbf41ji0/friends.json?dl=0";
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSError *error = nil;
    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error == nil) {
        
        NSArray *friendsArray = jsonArray.allValues;
        self.friendsArray = [NSMutableArray new];
        for (Friend *friends in friendsArray) {
            NSArray *imgs = [friends valueForKey:@"img"];
            NSArray *names = [friends valueForKey:@"name"];
            
            NSInteger friendsCount = imgs.count;
            for (int index = 0; index < friendsCount; index++) {
                // Name
                NSString *name = names[index];
                // Image
                NSString *imageString = imgs[index];
                NSURL *imageURL = [NSURL URLWithString:imageString];
                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                UIImage *image = [UIImage imageWithData:imageData];
                
                Friend *friend = [Friend new];
                friend.name = name;
                friend.image = image;
                [self.friendsArray addObject:friend];
            }
        }
        
        [_romashka stopAnimating];
        [self.tableView reloadData];
        
    } else {
        // Requst error
        NSString *errorReason = error.localizedDescription;
        NSLog(@"%@", errorReason);
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:errorReason preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler: nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

                                   
                                   
                                   
                                   
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friendsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Friend *currentFriend = self.friendsArray[indexPath.row];
    
    cell.friendsImageView.image = currentFriend.image;
    cell.friendsNameLabel.text = currentFriend.name;
    
    return cell;
}



@end
