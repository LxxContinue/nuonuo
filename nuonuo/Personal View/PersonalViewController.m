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
#import "UserInfo.h"

#import "SettingTableViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"

#import "LxxInterfaceConnection.h"
#import "SelectPhotoViewController.h"
#import "BindViewController.h"

#import "ToolCollect.h"

@interface PersonalViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property NSArray *dataSource;

@property UserInfo *userInfo;


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
    
    [self updateUserInfo];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)updateUserInfo
{
    LxxInterfaceConnection *connect = [[LxxInterfaceConnection alloc] init];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [connect connetNetWithGetMethod:@"nuoUsers/info" parms:dic block:^(int fail,NSString *dataMessage,NSDictionary *dictionary){
        if(fail == 0) {
            UserInfo *userInfo = [[UserInfo alloc] initWithNSDictionary:[dictionary objectForKey:@"data"]];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"userInfo"];
            [[NSUserDefaults standardUserDefaults] setObject:userInfo.accessToken forKey:@"accessToken"];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.userInfo = userInfo;
                [self.tableView reloadData];
            });
        }
    }];
}

#pragma mark - Private DataConfiguration
- (void)dataConfiguration{
    _dataSource = @[@"个人信息修改",@"问题与建议",@"检查与更新",@"设置",@"关于",@"绑定",@"退出登录"];
    
    NSData *deData = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    self.userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:deData];
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
    if(indexPath.row <6){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    if(indexPath.row ==0){
        SettingTableViewController *svc  = [[SettingTableViewController alloc]init];
        svc.userInfo = self.userInfo;
        svc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:svc animated:YES];
    }
    else if(indexPath.row == 5){
//        BindViewController *bvc = [[BindViewController alloc]init];
//        bvc.token = self.userInfo.accessToken;
//        bvc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:bvc animated:YES];
        
        [self getBindingInfo];
    }
    else if(indexPath.row ==6){
        [self logout];
    }
   
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"PersonalHeadView" owner:self options:nil];
    PersonalHeadView *head = [nibView objectAtIndex:0];

    head.nameLabel.text =[NSString stringWithFormat:@"%@",self.userInfo.name];
    
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

-(void)logout
{
    NSString *msg = [NSString stringWithFormat:@"\n确定要退出挪挪吗？"];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *appDomainStr = [[NSBundle mainBundle] bundleIdentifier];
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomainStr];
        LoginViewController *lvc = [[LoginViewController alloc] init];
        //UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:lvc];
        
        AppDelegate *delegete = (AppDelegate *)[[UIApplication  sharedApplication] delegate];
        //delegete.window.rootViewController = nav;
        delegete.window.rootViewController = lvc;
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];
    [alertController addAction:cancelAction];
    [alertController addAction:defaultAction];
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

-(void)getBindingInfo{
    NSString *getStr = [NSString stringWithFormat:@"photo/info"];
    
    NSMutableDictionary * parm = [[NSMutableDictionary alloc]init];
    LxxInterfaceConnection *connect = [[LxxInterfaceConnection alloc] init];
    [connect connetNetWithGetMethod:getStr parms:parm block:^(int fail,NSString *dataMessage,NSDictionary *dictionary) {
        if (fail ==0) {
            NSLog(@"search dataMessage：%@",dataMessage);
            
            NSDictionary *dic = [dictionary objectForKey:@"data"];

            NSMutableArray *arr = [[NSMutableArray alloc]init];
            arr = [dic objectForKey:@"otherPicNames"];

            dispatch_async(dispatch_get_main_queue(), ^{
                
                BindViewController *bvc = [[BindViewController alloc]init];
                bvc.token = self.userInfo.accessToken;
                if(arr.count==0){
                    bvc.Binding = NO;
                }else {
                    bvc.Binding = YES;
                    bvc.carPicStr = arr[0];
                    NSLog(@"%@",arr[0]);
                }
                
                bvc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:bvc animated:YES];

            });
        }
        else{
            BindViewController *bvc = [[BindViewController alloc]init];
            bvc.token = self.userInfo.accessToken;
            bvc.Binding = NO;
            bvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:bvc animated:YES];
        }
    }];
    
}




@end
