//
//  KKZTopUserCell.m
//  KanZhihu
//
//  Created by Kylin Roc on 1/26/16.
//  Copyright © 2016 Kylin Roc. All rights reserved.
//

#import "TopUserCell.h"

@implementation TopUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.avatarImageView.layer.cornerRadius = 30;
}

@end
