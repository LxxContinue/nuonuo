//
//  RegistViewController.m
//  nuonuo
//
//  Created by LXX on 2019/11/9.
//  Copyright © 2019年 LXX. All rights reserved.
//

#import "RegistViewController.h"

@interface RegistViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UITextField *mailText;

@end

static const CGFloat kTimeOutTime = 10.f;

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";

    [self dataConfiguration];
}

#pragma mark - Private DataConfiguration
- (void)dataConfiguration{
    
    self.phoneText.keyboardType = UIReturnKeyDefault;
    self.phoneText.delegate = self;
    
    self.passwordText.keyboardType = UIReturnKeyDefault;
    self.passwordText.delegate = self;
    
    self.mailText.keyboardType = UIReturnKeyDefault;
    self.mailText.delegate = self;
    
    self.mailText.text =@"623843876@qq.com";
    
}

-(void)regist{
    
    ///NSURL *url = [NSURL URLWithString:@"http://47.101.140.66:90/v1/users/register"];
    NSURL *url = [NSURL URLWithString:@"http://xyt.fzu.edu.cn:54321/v1/nuoUsers/register"];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kTimeOutTime];
    request.HTTPMethod = @"POST";
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:_phoneText.text forKey:@"phone"];
    [dic setObject:_passwordText.text forKey:@"password"];
    [dic setObject:_mailText.text forKey:@"email"];

    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    request.HTTPBody = data;

    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[[NSOperationQueue alloc]init]];
    
    //__block  NSString *result = @"";
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            //没有错误，返回正确；
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            NSLog(@"返回正确：%@",arr);
            
            NSLog(@"rrrdata2:%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"注册成功"
                                                                               message:@"一起来挪挪吧！"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {
                                                                          [self dismissViewControllerAnimated:YES completion:nil];
                                                                      }];
                
                [alert addAction:defaultAction];
                [self.navigationController presentViewController:alert animated:YES completion:nil];
                [self dismissViewControllerAnimated:YES completion:nil];
            });
            
        }else{
            //出现错误；
            NSLog(@"错误信息：%@",error);
        }
    }];
    [dataTask resume];
    
}

- (IBAction)confirmAction:(UIButton *)sender {
    
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
    
    NSLog(@"phone:%@passward:%@  email:%@",self.phoneText.text,self.passwordText.text,self.mailText.text);
    
    [self regist];
}
- (IBAction)cancelAction:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showError:(NSString *)errorMsg {
    // 1.弹框提醒
    // 初始化对话框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:errorMsg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    // 弹出对话框
    [self presentViewController:alert animated:true completion:nil];
}


@end
