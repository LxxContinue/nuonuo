//
//  MainViewController.m
//  nuonuo
//
//  Created by LXX on 2019/11/9.
//  Copyright © 2019年 LXX. All rights reserved.
//

#import "MainViewController.h"
#import "LoginViewController.h"
#import "RegistViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    

}

- (IBAction)showRegistView:(UIButton *)sender {
    RegistViewController *rvc = [[RegistViewController alloc]init];
    [self presentViewController:rvc animated:YES completion:nil];
    
}

- (IBAction)showLoginView:(UIButton *)sender {
    LoginViewController *lvc = [[LoginViewController alloc]init];
    [self presentViewController:lvc animated:YES completion:nil];
}

@end
