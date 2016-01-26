//
//  KKZTopUserCell.h
//  KanZhihu
//
//  Created by Kylin Roc on 1/26/16.
//  Copyright © 2016 Kylin Roc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopUserCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *indexLabel;
@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *signatureLabel;
@property (nonatomic, weak) IBOutlet UILabel *valueLabel;

@end
