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
    self.phoneText.keyboardType = UIReturnKeyDefault;
    self.phoneText.delegate = self;
    
    self.passwordText.keyboardType = UIReturnKeyDefault;
    self.passwordText.delegate = self;
    
    self.mailText.keyboardType = UIReturnKeyDefault;
    self.mailText.delegate = self;
}
-(void)regist{
    
    NSURL *url = [NSURL URLWithString:@"http://47.101.140.66:90/v1/users/register"];
    
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
            NSLog(@"%lu", data.length);
            
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
    
    [self regist];
}
- (IBAction)cancelAction:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
