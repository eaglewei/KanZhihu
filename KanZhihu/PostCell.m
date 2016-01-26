//
//  PostCell.m
//  KanZhihu
//
//  Created by Kylin Roc on 12/19/15.
//  Copyright © 2015 Kylin Roc. All rights reserved.
//

#import "PostCell.h"

@interface PostCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *excerptLabel;
@property (weak, nonatomic) IBOutlet UIButton *categoryButton;

@end

@implementation PostCell

- (void)setPost:(NSDictionary *)post
{
    _post = post;
    
    static NSDictionary *categoryName = nil;
    if (!categoryName) {
        categoryName = @{ @"recent": @"近日热门",
                          @"yesterday": @"昨日最新",
                          @"archive": @"历史精华" };
    }
    
    self.titleLabel.text = ({
        NSArray *array = [self.post[@"date"] componentsSeparatedByString:@"-"];
        [NSString stringWithFormat:@"%@年%@月%@日", array[0], array[1], array[2]];
    });
    self.excerptLabel.text = self.post[@"excerpt"];
    [self.categoryButton setTitle:categoryName[self.post[@"name"]] forState:UIControlStateNormal];
}

@end
