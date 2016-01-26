//
//  AnswerCell.m
//  KanZhihu
//
//  Created by Kylin Roc on 12/19/15.
//  Copyright © 2015 Kylin Roc. All rights reserved.
//

#import "AnswerCell.h"
#import <UIImageView+WebCache.h>

@interface AnswerCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIButton *authorNameButton;
@property (weak, nonatomic) IBOutlet UILabel *voteLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;

@end

@implementation AnswerCell

- (void)setAnswer:(NSDictionary *)answer
{
    _answer = answer;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.answer[@"avatar"]]
                            placeholderImage:[UIImage imageNamed:@"DefaultAvatar"]];
    [self.authorNameButton setTitle:self.answer[@"authorname"] forState:UIControlStateNormal];
    self.voteLabel.text = ({
        int vote = [self.answer[@"vote"] intValue];
        NSString *string = nil;
        if (vote >= 1000) {
            string = [NSString stringWithFormat:@" %.2gk ", vote / 1000.f];
        } else {
            string = [NSString stringWithFormat:@" %d ", vote];
        }
        string;
    });
    self.summaryLabel.text = ({
        NSString *summary = self.answer[@"summary"];
        if ([summary isEqualToString:@""]) {
            summary = @"[图片]";
        }
        summary;
    });
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.x += 10;
    frame.size.width -= 2 * 10;
    [super setFrame:frame];
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.avatarImageView.layer.cornerRadius = ({
        self.avatarImageView.clipsToBounds = YES;
        12.5f;
    });
    
    self.voteLabel.layer.backgroundColor = ({
        UIColor *backgroundColor = self.voteLabel.backgroundColor;
        self.voteLabel.backgroundColor = [UIColor clearColor];
        backgroundColor.CGColor;
    });
    self.voteLabel.layer.cornerRadius = ({
        self.voteLabel.clipsToBounds = YES;
        2.7f;
    });
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                                         cornerRadii:CGSizeMake(5.f, 5.f)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path  = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
    UIBezierPath *borderPath = [UIBezierPath bezierPath];
    [borderPath moveToPoint:self.bounds.origin];
    [borderPath addLineToPoint:CGPointMake(0, self.bounds.size.height - 5)];
    [borderPath addArcWithCenter:CGPointMake(5, self.bounds.size.height - 5)
                          radius:5.f
                      startAngle:M_PI
                        endAngle:M_PI / 2
                       clockwise:NO];
    [borderPath addLineToPoint:CGPointMake(self.bounds.size.width - 5, self.bounds.size.height)];
    [borderPath addArcWithCenter:CGPointMake(self.bounds.size.width - 5, self.bounds.size.height - 5)
                          radius:5.f
                      startAngle:M_PI / 2
                        endAngle:0
                       clockwise:NO];
    [borderPath addLineToPoint:CGPointMake(self.bounds.size.width, 0)];
    
    CAShapeLayer *borderLayer = [[CAShapeLayer alloc] init];
    borderLayer.frame = self.bounds;
    borderLayer.path  = borderPath.CGPath;
    borderLayer.lineWidth   = .5f;
    borderLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    borderLayer.fillColor   = [UIColor clearColor].CGColor;
    
    if ([self.layer.sublayers.lastObject isKindOfClass:[CAShapeLayer class]]) {
        [self.layer.sublayers.lastObject removeFromSuperlayer];
    }
    
    [self.layer addSublayer:borderLayer];
}
@end
