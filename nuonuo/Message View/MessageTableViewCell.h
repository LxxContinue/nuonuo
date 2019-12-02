//
//  MessageTableViewCell.h
//  nuonuo
//
//  Created by LXX on 2019/12/1.
//  Copyright © 2019年 LXX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

+(instancetype)cellInit:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
