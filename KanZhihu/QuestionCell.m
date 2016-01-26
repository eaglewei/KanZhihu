//
//  QuestionCell.m
//  KanZhihu
//
//  Created by Kylin Roc on 12/19/15.
//  Copyright © 2015 Kylin Roc. All rights reserved.
//

#import "QuestionCell.h"

@implementation QuestionCell

- (void)setFrame:(CGRect)frame
{
    frame.origin.x += 10;
    frame.size.width -= 2 * 10;
    [super setFrame:frame];
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                         cornerRadii:CGSizeMake(5.f, 5.f)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path  = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
    CAShapeLayer *borderLayer = [[CAShapeLayer alloc] init];
    borderLayer.frame = self.bounds;
    borderLayer.path  = maskPath.CGPath;
    borderLayer.lineWidth   = .5f;
    borderLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    borderLayer.fillColor   = [UIColor clearColor].CGColor;
    
    if ([self.layer.sublayers.lastObject isKindOfClass:[CAShapeLayer class]]) {
        [self.layer.sublayers.lastObject removeFromSuperlayer];
    }
    
    [self.layer addSublayer:borderLayer];
}

@end
