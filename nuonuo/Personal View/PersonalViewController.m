//
//  PersonalViewController.m
//  nuonuo
//
//  Created by LXX on 2019/11/10.
//  Copyright © 2019年 LXX. All rights reserved.
//

#import "PersonalViewController.h"
#import "PersonalHeadView.h"
#import "PersonalTableViewCell.h"


#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define kIs_iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define kIs_iPhoneX SCREEN_WIDTH >=375.0f && SCREEN_HEIGHT >=812.0f&& kIs_iphone
#define kStatusBarHeight (CGFloat)(kIs_iPhoneX?(44.0):(20.0))

@interface PersonalViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property NSArray *dataSource;

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self dataConfiguration];
    [self creatTable];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}


#pragma mark - Private DataConfiguration
- (void)dataConfiguration{
    _dataSource = @[@"个人信息修改",@"问题与建议",@"检查与更新",@"设置",@"关于",@"退出登录"];
}

-(void)creatTable{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,-kStatusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    CGRect frame=CGRectMake(0, 0, 0, CGFLOAT_MIN);
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:frame];
    self.tableView.backgroundColor = [UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1.0];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 300;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
//    if(!cell){
//        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
//    }
    
    PersonalTableViewCell * cell = [PersonalTableViewCell cellInit:self.tableView];

    cell.iconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_dataSource[indexPath.row]]];
    cell.hintLabel.text = [NSString stringWithFormat:@"%@",_dataSource[indexPath.row]];
    NSLog(@"!!!!%ld",(long)indexPath.row);
    if(indexPath.row <5){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
   
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"PersonalHeadView" owner:self options:nil];
    PersonalHeadView *head = [nibView objectAtIndex:0];

    head.nameLabel.text = @"辣鸡软工";
    
    head.headImage.image = [UIImage imageNamed:@"head"];
    head.headImage.layer.cornerRadius = 40;
    head.headImage.layer.masksToBounds = YES;


    head.backImage.image = [UIImage imageNamed:@"head"];


    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.alpha=0.9;
    effectview.frame = CGRectMake(0, 0,SCREEN_WIDTH, 230);
    [head.backImage addSubview:effectview];
    
    return head;
}




@end
