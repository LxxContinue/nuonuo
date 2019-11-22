//
//  SettingTableViewController.m
//  nuonuo
//
//  Created by LXX on 2019/11/22.
//  Copyright © 2019年 LXX. All rights reserved.
//

#import "SettingTableViewController.h"
#import "UserInfo.h"


#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define kIs_iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define kIs_iPhoneX SCREEN_WIDTH >=375.0f && SCREEN_HEIGHT >=812.0f&& kIs_iphone
#define kStatusBarHeight (CGFloat)(kIs_iPhoneX?(44.0):(20.0))

@interface SettingTableViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property NSArray *dataSource;

@property UserInfo *userInfo;
@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:62.0/255 green:54.0/255 blue:139.0/255 alpha:1.0];
    
    [self dataConfiguration];
    [self creatTable];
}
#pragma mark - Private DataConfiguration
- (void)dataConfiguration{
    _dataSource = @[@"名字",@"手机",@"性别",@"QQ",@"微信"];
    
    NSData *deData = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    self.userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:deData];
}

-(void)creatTable{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
//    CGRect frame=CGRectMake(0, 0, 0, CGFLOAT_MIN);
//    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:frame];
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  CGFLOAT_MIN;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if(!cell){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.dataSource[indexPath.row]];
    if(indexPath.row ==0){
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.userInfo.name];
    }
    else if(indexPath.row ==1){
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.userInfo.phone];
    }
    else if(indexPath.row ==2){
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.userInfo.sexual];
    }
    else if(indexPath.row ==3){
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.userInfo.qq];
    }
    else if(indexPath.row ==4){
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.userInfo.weixin];
    }
    





    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    

    
}




@end
