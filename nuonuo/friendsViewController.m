//
//  friendsViewController.m
//  nuonuo
//
//  Created by LXX on 2019/11/21.
//  Copyright © 2019年 LXX. All rights reserved.
//

#import "friendsViewController.h"

@interface friendsViewController ()

@end

@implementation friendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

-(void)setupView{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 300, 30)];
    label.text = [NSString stringWithFormat:@"动态"];
    [self.view addSubview:label];
}

@end
