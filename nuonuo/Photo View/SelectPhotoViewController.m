//
//  SelectPhotoViewController.m
//  nuonuo
//
//  Created by LXX on 2019/11/22.
//  Copyright © 2019年 LXX. All rights reserved.
//

#import "SelectPhotoViewController.h"

@interface SelectPhotoViewController ()

@end

@implementation SelectPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.carImageView.image = self.image;
    
    UIButton * returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(20, 40, 27, 22);
    [returnBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    returnBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [[returnBtn imageView] setContentMode:UIViewContentModeScaleAspectFill];
    returnBtn.contentHorizontalAlignment= UIControlContentHorizontalAlignmentFill;
    returnBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    [returnBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnBtn];
    

}

-(void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
