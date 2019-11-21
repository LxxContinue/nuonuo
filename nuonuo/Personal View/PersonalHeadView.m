//
//  PersonalHeadView.m
//  nuonuo
//
//  Created by LXX on 2019/11/10.
//  Copyright © 2019年 LXX. All rights reserved.
//

#import "PersonalHeadView.h"


@interface PersonalHeadView ()

@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation PersonalHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUpUI];
}

-(void)setUpUI {

    self.backView.layer.cornerRadius = 7;
    self.backView.layer.shadowOffset = CGSizeMake(3, 3);
    self.backView.layer.shadowOpacity = 0.4f;
    self.backView.layer.shadowColor = [UIColor grayColor].CGColor;
}




@end
