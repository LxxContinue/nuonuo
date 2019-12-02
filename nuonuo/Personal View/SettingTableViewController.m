//
//  SettingTableViewController.m
//  nuonuo
//
//  Created by LXX on 2019/11/22.
//  Copyright © 2019年 LXX. All rights reserved.
//

#import "SettingTableViewController.h"
#import "LxxInterfaceConnection.h"

#import "ToolCollect.h"

@interface SettingTableViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property NSArray *dataSource;


@property (nonatomic, strong) NSString * nameStr;
@property (nonatomic, strong) NSString * sexStr;
@property (nonatomic, strong) NSString * qqStr;
@property (nonatomic, strong) NSString * weixinStr;
@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.title = @"个人信息";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:62.0/255 green:54.0/255 blue:139.0/255 alpha:1.0];
    
    UIButton *rButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,45,45)];
    [rButton setTitle:@"保存" forState:UIControlStateNormal];
    rButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    UIBarButtonItem  *rButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rButton];
    rButton.backgroundColor=[UIColor clearColor];
    [rButton addTarget:self action:@selector(confirmSave) forControlEvents:UIControlEventTouchDown];
    self.navigationItem.rightBarButtonItem = rButtonItem;
    
    
    [self dataConfiguration];
    [self creatTable];
}
#pragma mark - Private DataConfiguration
- (void)dataConfiguration{
    _dataSource = @[@"名字",@"手机",@"性别",@"QQ",@"微信"];
    
    self.nameStr = self.userInfo.name;
    self.sexStr = self.userInfo.sexual;
    self.qqStr = self.userInfo.qq;
    self.weixinStr = self.userInfo.weixin;
    
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

-(void)confirmSave{
    LxxInterfaceConnection *connect = [[LxxInterfaceConnection alloc] init];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *putUrl = [NSString stringWithFormat:@"nuoUsers/profile"];
    
    [dic setObject:self.nameStr forKey:@"name"];
    [dic setObject:self.sexStr forKey:@"gender"];
    
//    if(self.qqStr !=nil && ![self.qqStr isKindOfClass:[NSNull class]]){
//        self.qqStr = @" ";
//    }
//    if(self.weixinStr !=nil && ![self.weixinStr isKindOfClass:[NSNull class]]){
//        self.weixinStr = @" ";
//    }
    
    [dic setObject:self.qqStr forKey:@"qq"];
    [dic setObject:self.weixinStr forKey:@"weixin"];
    //[dic setObject:@"2041" forKey:@"headPicId"];
    
    
//    [dic setObject:self.qqStr forKey:@"qq"];
//    [dic setObject:self.weixinStr forKey:@"weixin"];
//    [dic setObject:@"2040" forKey:@"headPicId"];
    
    [connect connetNetWithPutMethod:putUrl parms:dic  block:^(int fail,NSString *dataMessage,NSDictionary *dictionary){
        
        NSLog(@"rrrdata2:%@",dictionary);
        
        if(fail == 0) {
            dispatch_async(dispatch_get_main_queue(),^{
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"修改成功"
                                                                               message:@"一起来挪挪吧！"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {
                                                                          [self.navigationController popViewControllerAnimated:YES];
                                                                      }];
                
                [alert addAction:defaultAction];
                [self.navigationController presentViewController:alert animated:YES completion:nil];
                
            });
        } else {
            dataMessage = [NSString stringWithFormat:@"\n%@",dataMessage];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:dataMessage preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:defaultAction];
            [self.navigationController presentViewController:alertController animated:YES completion:nil];
        }
    }];
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
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.sexStr];
    }
    else if(indexPath.row ==3){
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.qqStr];
    }
    else if(indexPath.row ==4){
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.weixinStr];
    }
    
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    if(indexPath.row ==0){
        [self showNameInput];
    }else if(indexPath.row ==2){
        [self showSexInput];
    }else if(indexPath.row ==3){
        [self showQQInput];
    }else if(indexPath.row ==4){
        [self showWeixinInput];
    }
    
}

- (void)showNameInput {
    UIAlertController *mailInputAlert = [UIAlertController alertControllerWithTitle:@"请输入您要修改的名称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [mailInputAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = self.nameStr;
        textField.returnKeyType = UIReturnKeyDone;
        [textField addTarget:self action:@selector(strDidChanged:)
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


- (void)showSexInput {
    UIAlertController *mailInputAlert = [UIAlertController alertControllerWithTitle:@"请输入您的性别" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [mailInputAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = self.sexStr;
        textField.returnKeyType = UIReturnKeyDone;
        [textField addTarget:self action:@selector(strDidChanged:)
            forControlEvents:UIControlEventEditingChanged];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.sexStr = mailInputAlert.textFields.firstObject.text;
        NSIndexPath *path = [NSIndexPath indexPathForRow:2 inSection:0];//指定cell
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:path,nil] withRowAnimation:UITableViewRowAnimationNone];
    }];
    saveAction.enabled = NO;
    [mailInputAlert addAction:cancelAction];
    [mailInputAlert addAction:saveAction];
    [self presentViewController:mailInputAlert animated:YES completion:nil];
}


- (void)showQQInput {
    UIAlertController *mailInputAlert = [UIAlertController alertControllerWithTitle:@"请输入您的qq" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [mailInputAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = self.qqStr;
        textField.returnKeyType = UIReturnKeyDone;
        [textField addTarget:self action:@selector(strDidChanged:)
            forControlEvents:UIControlEventEditingChanged];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.qqStr = mailInputAlert.textFields.firstObject.text;
        NSIndexPath *path = [NSIndexPath indexPathForRow:3 inSection:0];//指定cell
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:path,nil] withRowAnimation:UITableViewRowAnimationNone];
    }];
    saveAction.enabled = NO;
    [mailInputAlert addAction:cancelAction];
    [mailInputAlert addAction:saveAction];
    [self presentViewController:mailInputAlert animated:YES completion:nil];
}


- (void)showWeixinInput {
    UIAlertController *mailInputAlert = [UIAlertController alertControllerWithTitle:@"请输入您的微信" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [mailInputAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = self.weixinStr;
        textField.returnKeyType = UIReturnKeyDone;
        [textField addTarget:self action:@selector(strDidChanged:)
            forControlEvents:UIControlEventEditingChanged];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.weixinStr = mailInputAlert.textFields.firstObject.text;
        NSIndexPath *path = [NSIndexPath indexPathForRow:4 inSection:0];//指定cell
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:path,nil] withRowAnimation:UITableViewRowAnimationNone];
    }];
    saveAction.enabled = NO;
    [mailInputAlert addAction:cancelAction];
    [mailInputAlert addAction:saveAction];
    [self presentViewController:mailInputAlert animated:YES completion:nil];
}

- (void)strDidChanged:(UITextField *)sender {
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if(alertController) {
        NSString *inputMail = alertController.textFields.firstObject.text;
        UIAlertAction *saveAction = alertController.actions.lastObject;
        if(![inputMail isEqualToString:@""]) {
            saveAction.enabled = YES;
        }
        
    }
}



@end
