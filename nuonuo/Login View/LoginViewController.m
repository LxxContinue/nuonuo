//
//  LoginViewController.m
//  nuonuo
//
//  Created by LXX on 2019/11/9.
//  Copyright © 2019年 LXX. All rights reserved.
//

#import "LoginViewController.h"

#import "AppDelegate.h"
#import "RegistViewController.h"
#import "UserInfo.h"
#import "MainViewController.h"
#import "HomeViewController.h"
#import "TabBarViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;

@end

static const CGFloat kTimeOutTime = 10.f;

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    self.title = @"登录";
    

    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationItem setHidesBackButton:YES];
    
}

#pragma mark - Private DataConfiguration
- (void)dataConfiguration{
    

    
}

- (IBAction)loginAction:(UIButton *)sender {

//    TabBarViewController *tvc = [[TabBarViewController alloc ] init];
//    // 获取主代理
//    AppDelegate *delegete = (AppDelegate *)[[UIApplication  sharedApplication] delegate];
//    delegete.window.rootViewController = tvc;
    
    NSString*pattern =@"^[0-9]{11}";
    NSPredicate*pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    if(![pred evaluateWithObject:_phoneText.text]) {
        [self showError:@"请输入11位正确手机号"];
        return;
    }

    if (_passwordText.text.length == 0) {
        [self showError:@"请输入密码"];
        return;
    }
    
    [self login];
}

-(void)login{

    //NSURL *url = [NSURL URLWithString:@"http://47.101.140.66:90/v1/users/login"];
    NSURL *url = [NSURL URLWithString:@"http://xyt.fzu.edu.cn:54321/v1/nuoUsers/login"];

    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kTimeOutTime];
    request.HTTPMethod = @"POST";

    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:_phoneText.text forKey:@"account"];
    [dic setObject:_passwordText.text forKey:@"password"];
    
    NSLog(@"phone:%@---password:%@",self.phoneText.text,self.passwordText.text);
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    request.HTTPBody = data;

    //    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[[NSOperationQueue alloc]init]];
    
    __block  NSString *result = @"";
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            UserInfo *userInfo = [[UserInfo alloc] initWithNSDictionary:[dict objectForKey:@"data"] ];
            NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
            [[NSUserDefaults standardUserDefaults] setObject:userData forKey:@"userInfo"];
            
            result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"返回正确：%@",result);
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            NSLog(@"login返回正确：%@",arr);
            
            dispatch_async(dispatch_get_main_queue(), ^{
//                MainViewController *mvc = [[MainViewController alloc ] init];
//                // 获取主代理
//                AppDelegate *delegete = (AppDelegate *)[[UIApplication  sharedApplication] delegate];
//                delegete.window.rootViewController = mvc;
                
                TabBarViewController *tvc = [[TabBarViewController alloc ] init];
                // 获取主代理
                AppDelegate *delegete = (AppDelegate *)[[UIApplication  sharedApplication] delegate];
                delegete.window.rootViewController = tvc;
            });
            
        }else{
            NSLog(@"错误信息：%@",error);
        }
    }];
    [dataTask resume];
    
}

- (IBAction)registAction:(UIButton *)sender {
    RegistViewController *rvc = [[RegistViewController alloc]init];

    //[self.navigationController pushViewController:rvc animated:YES];
    [self presentViewController:rvc animated:YES completion:nil];
    
}

- (IBAction)forgetAction:(UIButton *)sender {
    
}

- (void)showError:(NSString *)errorMsg {
    // 1.弹框提醒
    // 初始化对话框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:errorMsg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    // 弹出对话框
    [self presentViewController:alert animated:true completion:nil];
}

#pragma mark - UITextFieldDelegate
//点击return收起键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end
