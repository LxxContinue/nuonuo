//
//  PersonalTableViewCell.m
//  nuonuo
//
//  Created by LXX on 2019/11/10.
//  Copyright © 2019年 LXX. All rights reserved.
//

#import "PersonalTableViewCell.h"

@implementation PersonalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}
- (void)setFrame:(CGRect)frame
{
    //frame.size.height -= 12;
    frame.origin.x += 25;
    //frame.origin.y += 6;
    frame.size.width -= 50;
    
    [super setFrame:frame];
}


+(instancetype)cellInit:(UITableView *)tableView{
    static NSString *identifier=@"PersonalTableViewCell";
    PersonalTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell=[[[NSBundle mainBundle]loadNibNamed:@"PersonalTableViewCell" owner:nil options:nil]firstObject];
    }
    return cell;
}



@end
