//
//  TopAnswersViewController.m
//  KanZhihu
//
//  Created by Kylin Roc on 12/24/15.
//  Copyright © 2015 Kylin Roc. All rights reserved.
//

#import "TopAnswersViewController.h"
#import "TopAnswerCell.h"

@interface TopAnswersViewController ()

@end

@implementation TopAnswersViewController

- (void)setTopAnswers:(NSArray *)topAnswers
{
    _topAnswers = topAnswers;
    [self.tableView reloadData];
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 44.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.topAnswers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TopAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TopAnswerCell class])
                                                          forIndexPath:indexPath];
    cell.answer = self.topAnswers[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *answer = self.topAnswers[indexPath.row];
    NSURL *URL = nil;
    if ([answer[@"ispost"] isEqualToString:@"0"]) {
        URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.zhihu.com%@", answer[@"link"]]];
    } else {
        URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://zhuanlan.zhihu.com%@", answer[@"link"]]];
    }
    [[UIApplication sharedApplication] openURL:URL];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

@end
