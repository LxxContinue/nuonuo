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

@interface OwerViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (nonatomic) NSString * token ;

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
    
    NSString *str = [NSString stringWithFormat:@"http://xyt.fzu.edu.cn:54321/v1/message/%@",@"2"];

    NSURL *url = [NSURL URLWithString:str];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kTimeOutTime];
    request.HTTPMethod = @"POST";
    
    [request setValue:self.token forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"辣鸡软工是真的垃圾" forKey:@"content"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    request.HTTPBody = data;
    
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//    [dic setObject:@"what" forKey:@"content"];
//
//    NSError *error;
//    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:dic options:0 error:&error]];
    

    
    
    
    
    
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setObject:@"what" forKey:@"content"];
    
//    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
//    request.HTTPBody = data;
    
//    NSString *content =@"";
//    content=[NSString stringWithFormat:@"%@=%@",@"content",@"what"];
//
//    NSMutableData *postBody=[NSMutableData data];
//    [postBody appendData:[content dataUsingEncoding:NSUTF8StringEncoding]];
//    request.HTTPBody = postBody;
    

    
//    NSString *content = @"";
//    content = [self convertToJsonData:dic];
//    NSLog(@"contentStr:%@",content);
//    NSData * data = [content dataUsingEncoding:NSUTF8StringEncoding];
//    request.HTTPBody = data;
    
    
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[[NSOperationQueue alloc]init]];
    
    //__block  NSString *result = @"";
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            //没有错误，返回正确；
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            NSLog(@"返回正确：%@",arr);
            
            NSLog(@"rrrdata2:%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
            
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
