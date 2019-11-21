//
//  SearchViewController.m
//  nuonuo
//
//  Created by LXX on 2019/11/21.
//  Copyright © 2019年 LXX. All rights reserved.
//

#import "SearchViewController.h"
#import "LxxInterfaceConnection.h"

@interface SearchViewController ()

@property (nonatomic,strong) NSMutableArray *infoArr;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getDetail];
}

#pragma mark - Private DataConfiguration
- (void)dataConfiguration{
    
}


-(void)getDetail{
    NSString *getStr = [NSString stringWithFormat:@"photo/%s","1223"];
    
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
}

@end
