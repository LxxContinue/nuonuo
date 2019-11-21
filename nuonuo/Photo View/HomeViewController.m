//
//  HomeViewController.m
//  nuonuo
//
//  Created by LXX on 2019/11/9.
//  Copyright © 2019年 LXX. All rights reserved.
//

#import "HomeViewController.h"
#import "SearchViewController.h"

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _backView.layer.shadowOffset = CGSizeMake(0, 0);
    _backView.layer.shadowOpacity=0.6f;
    _backView.layer.shadowColor=[UIColor grayColor].CGColor;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (IBAction)confirmAction:(UIButton *)sender {
    
    SearchViewController *svc = [[SearchViewController alloc]init];
    [self presentViewController:svc animated:YES completion:nil];
}



@end
