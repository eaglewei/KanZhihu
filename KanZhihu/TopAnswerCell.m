//
//  TopAnswerCell.m
//  KanZhihu
//
//  Created by Kylin Roc on 12/24/15.
//  Copyright © 2015 Kylin Roc. All rights reserved.
//

#import "TopAnswerCell.h"

@interface TopAnswerCell ()

@property (nonatomic, weak) IBOutlet UILabel *agreeLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@end

@implementation TopAnswerCell

- (void)setAnswer:(NSDictionary *)answer
{
    _answer = answer;
    
    self.agreeLabel.text = ({
        int agree = [self.answer[@"agree"] intValue];
        NSString *text = nil;
        if (agree >= 1000) {
            text = [NSString stringWithFormat:@"%.2gk", agree / 1000.f];
        } else {
            text = [NSString stringWithFormat:@"%d", agree];
        }
        text;
    });
    self.titleLabel.text = self.answer[@"title"];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.agreeLabel.layer.backgroundColor = ({
        UIColor *backgroundColor = self.agreeLabel.backgroundColor;
        self.agreeLabel.backgroundColor = [UIColor clearColor];
        backgroundColor.CGColor;
    });
    
    self.agreeLabel.layer.cornerRadius = ({
        self.agreeLabel.clipsToBounds = YES;
        3.9f;
    });
}

@end
