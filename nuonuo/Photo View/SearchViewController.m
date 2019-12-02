//
//  SearchViewController.m
//  nuonuo
//
//  Created by LXX on 2019/11/21.
//  Copyright © 2019年 LXX. All rights reserved.
//

#import "SearchViewController.h"
#import "LxxInterfaceConnection.h"
#import "OwerViewController.h"

@interface SearchViewController ()

@property (nonatomic,strong) NSMutableArray *infoArr;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"]  style:UIBarButtonItemStyleDone target:self action:@selector(popAction)];
//    self.navigationItem.leftBarButtonItem = leftBarItem;
//
//    self.navigationItem.leftBarButtonItem = leftBarItem;
//    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
////    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:62.0/255 green:54.0/255 blue:139.0/255 alpha:1.0];
    

    
    [self dataConfiguration];
    [self getDetail];
    
}

-(void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private DataConfiguration
- (void)dataConfiguration{
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


-(void)getDetail{
    NSString *getStr = [NSString stringWithFormat:@"photo/%@",@"sycnz"];
    
    NSMutableDictionary * parm = [[NSMutableDictionary alloc]init];
    LxxInterfaceConnection *connect = [[LxxInterfaceConnection alloc] init];
    [connect connetNetWithGetMethod:getStr parms:parm block:^(int fail,NSString *dataMessage,NSDictionary *dictionary) {
        if (fail ==0) {
            
            NSLog(@"search dataMessage：%@",dataMessage);
            
            //获取匹配到的车信息
            self.infoArr = [[NSMutableArray alloc]init];
            self.infoArr = [dictionary objectForKey:@"data"];
            
            NSLog(@"search arr：%@",self.infoArr);

            
            dispatch_async(dispatch_get_main_queue(), ^{

                [self setupView];
            });
        }
    }];
    
}

-(void)setupView{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 300, 30)];
    NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:self.infoArr[0]];
    label.text = [NSString stringWithFormat:@"姓名：%@",[dic objectForKey:@"name"]];
    [self.view addSubview:label];
    
    UILabel *carIDLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 300, 300, 30)];
    carIDLabel.text = [NSString stringWithFormat:@"车牌：%@",self.carID];
    [self.view addSubview:carIDLabel];
    
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(30, 300, 100, 30);
    [confirmBtn setBackgroundColor:[UIColor blueColor]];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
}

-(void)confirmAction{
    OwerViewController *ovc = [[OwerViewController alloc]init];
    [self.navigationController pushViewController:ovc animated:YES];
}

@end
