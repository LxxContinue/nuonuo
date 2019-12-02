//
//  MessageTableViewCell.m
//  nuonuo
//
//  Created by LXX on 2019/12/1.
//  Copyright © 2019年 LXX. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)cellInit:(UITableView *)tableView{
    static NSString *identifier=@"MessageTableViewCell";
    MessageTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell=[[[NSBundle mainBundle]loadNibNamed:@"MessageTableViewCell" owner:nil options:nil]firstObject];
    }
    return cell;
}


@end
