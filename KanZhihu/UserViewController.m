//
//  UserViewController.m
//  KanZhihu
//
//  Created by Kylin Roc on 12/23/15.
//  Copyright © 2015 Kylin Roc. All rights reserved.
//

#import "UserViewController.h"

#import "TopAnswersViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface UserViewController ()

@property (strong, nonatomic) NSDictionary *userInfo;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *signatureScrollView;
@property (weak, nonatomic) IBOutlet UILabel *answersNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *followeesNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *agreeNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *thanksNumberLabel;

@end

@implementation UserViewController

- (void)setUserInfo:(NSDictionary *)userInfo {
    _userInfo = userInfo;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.userInfo[@"avatar"]]
                            placeholderImage:[UIImage imageNamed:@"DefaultAvatar"]];
    [self.signatureScrollView addSubview:({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        label.text = self.userInfo[@"signature"];
        if ([label.text isEqualToString:@""]) {
            label.text = self.userInfo[@"name"];
        }
        label.textColor = self.descriptionLabel.textColor;
        [label sizeToFit];
        self.signatureScrollView.contentSize = label.bounds.size;
        label;
    })];
    self.descriptionLabel.text = self.userInfo[@"description"];
    
    NSDictionary *detail = self.userInfo[@"detail"];
    self.answersNumberLabel.text = detail[@"answer"];
    self.followeesNumberLabel.text = detail[@"followee"];
    self.followersNumberLabel.text = detail[@"follower"];
    self.agreeNumberLabel.text = detail[@"agree"];
    self.thanksNumberLabel.text = detail[@"thanks"];
    
    [self.tableView reloadData];
    
    self.tableView.userInteractionEnabled = YES;
}

- (IBAction)homepageButtonTouched:(id)sender {
    NSString *URLString = [NSString stringWithFormat:@"http://www.zhihu.com/people/%@", self.userHash];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 169.5f;
    
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 32.5f;
    self.descriptionLabel.text = @"";
    
    NSString *URLString = [NSString stringWithFormat:@"http://api.kanzhihu.com/userdetail2/%@", self.userHash];
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:URLString]
                                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response,
                                                     NSError * _Nullable error) {
                                     if (error != NULL) {
                                         return;
                                     }
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         self.userInfo = [NSJSONSerialization JSONObjectWithData:data
                                                                                         options:0
                                                                                           error:nil];
                                     });
                                 }] resume];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[TopAnswersViewController class]]) {
        TopAnswersViewController *tavc = segue.destinationViewController;
        tavc.topAnswers = self.userInfo[@"topanswers"];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

@end
