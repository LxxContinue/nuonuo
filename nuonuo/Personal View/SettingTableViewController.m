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

@property (nonatomic, strong) NSString * nameStr;
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
    
    self.nameStr = self.userInfo.name;
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
        cell.detailTextLabel.text = self.nameStr;
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
    
    if(indexPath.row ==0){
        [self  showNameInput];
    }
    
}

- (void)showNameInput {
    UIAlertController *mailInputAlert = [UIAlertController alertControllerWithTitle:@"请输入您要修改的名称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [mailInputAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = self.nameStr;
        textField.returnKeyType = UIReturnKeyDone;
        [textField addTarget:self action:@selector(nameDidChanged:)
            forControlEvents:UIControlEventEditingChanged];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.nameStr = mailInputAlert.textFields.firstObject.text;
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];//指定cell
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:path,nil] withRowAnimation:UITableViewRowAnimationNone];
    }];
    saveAction.enabled = NO;
    [mailInputAlert addAction:cancelAction];
    [mailInputAlert addAction:saveAction];
    [self presentViewController:mailInputAlert animated:YES completion:nil];
}

- (void)nameDidChanged:(UITextField *)sender {
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if(alertController) {
        NSString *inputMail = alertController.textFields.firstObject.text;
        UIAlertAction *saveAction = alertController.actions.lastObject;
        if(![inputMail isEqualToString:@""]) {
            saveAction.enabled = YES;
            //self.mailModify = true;
            
            //            if([inputMail containsString:@"@"]){
            //                saveAction.enabled = YES;
            //                self.mailModify = true;
            //            }
            //            else{
            //                [LCProgressHUD showFailure:@"请输入正确邮箱格式@"];
            //            }
        }
        
    }
}



@end
