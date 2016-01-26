//
//  HomeViewController.m
//  KanZhihu
//
//  Created by Kylin Roc on 12/19/15.
//  Copyright © 2015 Kylin Roc. All rights reserved.
//

#import "HomeViewController.h"
#import "PostViewController.h"
#import "PostCell.h"

@interface HomeViewController ()

@property (nonatomic, strong) NSArray *posts;

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 68.5;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [UIView new];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"http://api.kanzhihu.com/getposts"]
                                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response,
                                                     NSError * _Nullable error) {
                                     if (error != NULL) {
                                         return;
                                     }
                                     NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                                          options:0
                                                                                            error:nil];
                                     self.posts = json[@"posts"];
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         [self.tableView reloadData];
                                     });
                                 }] resume];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[PostViewController class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *post = self.posts[indexPath.row];
        NSArray *array = [post[@"date"] componentsSeparatedByString:@"-"];
        PostViewController *pvc = segue.destinationViewController;
        pvc.postURL = [NSURL URLWithString:({
            NSMutableString *string = [[NSMutableString alloc] init];
            [string appendString:@"http://api.kanzhihu.com/getpostanswers/"];
            [string appendFormat:@"%@%@%@/%@", array[0], array[1], array[2], post[@"name"]];
            [string copy];
        })];
        pvc.navigationItem.title = ({
            static NSDictionary *categoryName = nil;
            if (!categoryName) {
                categoryName = @{ @"recent": @"近日热门",
                                  @"yesterday": @"昨日最新",
                                  @"archive": @"历史精华" };
            }
            [NSString stringWithFormat:@"%@年%@月%@日%@", array[0], array[1], array[2], categoryName[post[@"name"]]];
        });
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell" forIndexPath:indexPath];
    cell.post = self.posts[indexPath.row];
    return cell;
}

@end
