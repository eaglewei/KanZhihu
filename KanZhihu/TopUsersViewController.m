//
//  TopUsersViewController.m
//  KanZhihu
//
//  Created by Kylin Roc on 1/26/16.
//  Copyright © 2016 Kylin Roc. All rights reserved.
//

#import "TopUsersViewController.h"

#import "TopUserCell.h"
#import "UserViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface TopUsersViewController ()

@property (nonatomic) NSUInteger currentPage;
@property (nonatomic) NSMutableArray *topUsers;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation TopUsersViewController

- (NSMutableArray *)topUsers {
    if (!_topUsers) {
        _topUsers = [NSMutableArray array];
    }
    return _topUsers;
}

- (void)loadMore {
    NSMutableString *URLString = [@"http://api.kanzhihu.com/topuser/" mutableCopy];
    if (self.segmentedControl.selectedSegmentIndex) {
        [URLString appendString:@"follower"];
    } else {
        [URLString appendString:@"agree"];
    }
    [URLString appendFormat:@"/%lu/50", (unsigned long)++self.currentPage];
    NSURL *URL = [NSURL URLWithString:URLString];
    NSURLSession *session = [NSURLSession sharedSession];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[session dataTaskWithURL:URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (error) {
            // Handle error
            
        } else {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            [self.topUsers addObjectsFromArray:json[@"topuser"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }] resume];
}

- (IBAction)changeRule {
    self.currentPage = 0;
    self.topUsers = [NSMutableArray array];
    [self.tableView reloadData];
    [self loadMore];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadMore];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[UserViewController class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *user = self.topUsers[indexPath.row];
        ((UserViewController *)segue.destinationViewController).userHash = user[@"hash"];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.topUsers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *topUser = self.topUsers[indexPath.row];
    TopUserCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TopUserCell class]) forIndexPath:indexPath];
    [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:topUser[@"avatar"]]];
    cell.indexLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row + 1];
    cell.nameLabel.text = topUser[@"name"];
    cell.signatureLabel.text = topUser[@"signature"];
    if (self.segmentedControl.selectedSegmentIndex) {
        [cell.valueLabel setText:[NSString stringWithFormat:@"粉丝数：%@", topUser[@"follower"]]];
    } else {
        [cell.valueLabel setText:[NSString stringWithFormat:@"赞同数：%@", topUser[@"agree"]]];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.topUsers.count - 1) {
        [self loadMore];
    }
}

@end
