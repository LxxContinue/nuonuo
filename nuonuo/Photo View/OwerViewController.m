//
//  OwerViewController.m
//  nuonuo
//
//  Created by LXX on 2019/11/23.
//  Copyright © 2019年 LXX. All rights reserved.
//

#import "OwerViewController.h"
#import "UserInfo.h"
#import "LxxInterfaceConnection.h"
#import "HomeViewController.h"

@interface OwerViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;

@property (nonatomic) NSString * token ;

@property (nonatomic) NSString * message ;

@end


static const CGFloat kTimeOutTime = 10.f;

@implementation OwerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton * returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(20, 40, 27, 22);
    [returnBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    returnBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [[returnBtn imageView] setContentMode:UIViewContentModeScaleAspectFill];
    returnBtn.contentHorizontalAlignment= UIControlContentHorizontalAlignmentFill;
    returnBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    [returnBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnBtn];
    
    [self dataConfiguration];
    
    
}
#pragma mark - Private DataConfiguration
- (void)dataConfiguration{
    self.message = [[NSString alloc]init];
    
    
    self.headImage.layer.cornerRadius = 50;
    self.headImage.layer.masksToBounds = YES;
    
    self.nameLabel.text = @"sycnz";
    
    self.messageBtn.layer.cornerRadius = 20;
    self.messageBtn.layer.shadowOffset = CGSizeMake(3, 3);
    self.messageBtn.layer.shadowOpacity = 0.3f;
    self.messageBtn.layer.shadowColor = [UIColor grayColor].CGColor;
    self.messageBtn.backgroundColor = [UIColor whiteColor];
    
    self.phoneBtn.layer.cornerRadius = 20;
    self.phoneBtn.layer.shadowOffset = CGSizeMake(3, 3);
    self.phoneBtn.layer.shadowOpacity = 0.3f;
    self.phoneBtn.layer.shadowColor = [UIColor grayColor].CGColor;
    self.phoneBtn.backgroundColor = [UIColor whiteColor];
    
    NSData *deData = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    UserInfo * userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:deData];
    self.token = userInfo.accessToken;
}

-(void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)messageAction:(UIButton *)sender {
    NSLog(@"message!");
    
    UIAlertController *InputAlert = [UIAlertController alertControllerWithTitle:@"请输入您要发送的消息" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [InputAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = @"";
        textField.returnKeyType = UIReturnKeyDone;
        [textField addTarget:self action:@selector(strDidChanged:)
            forControlEvents:UIControlEventEditingChanged];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.message = InputAlert.textFields.firstObject.text;
        [self messageConfirm];
    }];
    saveAction.enabled = NO;
    [InputAlert addAction:cancelAction];
    [InputAlert addAction:saveAction];
    [self presentViewController:InputAlert animated:YES completion:nil];
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
-(void)messageConfirm{
    NSString *str = [NSString stringWithFormat:@"http://xyt.fzu.edu.cn:54321/v1/message/%@",self.owerId];
    NSURL *url = [NSURL URLWithString:str];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kTimeOutTime];
    request.HTTPMethod = @"POST";
    
    [request setValue:self.token forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.message forKey:@"content"];
    
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
            
            UIAlertController *successAlert = [UIAlertController alertControllerWithTitle:nil message:@"消息已发出，请耐心等待" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                for (UIViewController *controller in self.navigationController.viewControllers)
                {
                    if ([controller isKindOfClass:[HomeViewController class]]) {
                        HomeViewController *hvc =(HomeViewController *)controller;
                        [self.navigationController popToViewController:hvc animated:YES];
                    }
                }
            }];
            [successAlert addAction:confirmAction];
            [self presentViewController:successAlert animated:YES completion:nil];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
            
        }else{
            //出现错误；
            NSLog(@"错误信息：%@",error);
        }
    }];
    [dataTask resume];
}

- (IBAction)phoneAction:(UIButton *)sender {
    NSLog(@"phone!");
}

-(NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    //    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    //    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
    
}


@end
