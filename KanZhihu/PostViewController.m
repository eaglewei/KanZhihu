//
//  PostViewController.m
//  KanZhihu
//
//  Created by Kylin Roc on 12/19/15.
//  Copyright © 2015 Kylin Roc. All rights reserved.
//

#import "PostViewController.h"

#import "AnswerCell.h"
#import "QuestionCell.h"
#import "UserViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface PostViewController ()

@property (strong, nonatomic) NSArray *answers;

@end

@implementation PostViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.estimatedRowHeight = 85.5;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH / 2)];
    [headerView sd_setImageWithURL:self.picURL];
    self.tableView.tableHeaderView = headerView;
    
    [[[NSURLSession sharedSession] dataTaskWithURL:self.postURL
                                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response,
                                                     NSError * _Nullable error) {
                                     if (error != NULL) {
                                         return;
                                     }
                                     NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                                          options:0
                                                                                            error:nil];
                                     self.answers = json[@"answers"];
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         [self.tableView reloadData];
                                         
                                     });
                                 }] resume];
    [self.tableView setContentOffset:CGPointMake(0, SCREEN_WIDTH / 2) animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    NSDictionary *answer = self.answers[indexPath.section];
    UserViewController *uvc = segue.destinationViewController;
    uvc.userHash = answer[@"authorhash"];
    uvc.navigationItem.title = answer[@"authorname"];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.answers.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *answer = self.answers[indexPath.section];
    if (indexPath.row == 0) {
        QuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Question Cell" forIndexPath:indexPath];
        cell.titleLabel.text = answer[@"title"];
        cell.titleLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 69;
        return cell;
    } else {
        AnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Answer Cell" forIndexPath:indexPath];
        cell.answer = answer;
        return cell;
    }
}

#pragma mark - UITabelViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *answer = self.answers[indexPath.section];
    NSMutableString *string = [NSMutableString new];
    [string appendFormat:@"http://www.zhihu.com/question/%@", answer[@"questionid"]];
    if (indexPath.row) {
        [string appendFormat:@"/answer/%@", answer[@"answerid"]];
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
