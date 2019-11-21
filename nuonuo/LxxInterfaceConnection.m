//
//  LxxInterfaceConnection.m
//  CardGame
//
//  Created by LXX on 2019/9/28.
//  Copyright © 2019年 LXX. All rights reserved.
//

#import "LxxInterfaceConnection.h"
#import "UserInfo.h"

@interface LxxInterfaceConnection()

@property  NSURLSession *session;
@property (nonatomic) NSString * token ;

@end

const CGFloat kTimeOutTime = 10.f;

@implementation LxxInterfaceConnection

- (id)init {
    self = [super init];
    if(self) {
        //创建会话
        self.session=[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[[NSOperationQueue alloc]init]];
        NSData *deData = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
        UserInfo * userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:deData];
        self.token = userInfo.accessToken;
    }
    return self;
}


-(void)connetNetWithGetMethod:(NSString *)handle parms:(NSDictionary *)params block:(void (^)(int, NSString * _Nonnull, NSDictionary * _Nonnull))block{
    __block BOOL getFail=1;
    __block NSString *dataMessage;
    NSString *urlStr = [NSString stringWithFormat:NetURL,handle];
    
//    //设置请求头参数
//    NSArray *keys=[params allKeys];
//    NSString *content = @"";
//    if(keys.count>0)
//        content = [NSString stringWithFormat:@"%@=%@",keys[0],[params objectForKey:keys[0]]];
//    if(keys.count>1)
//        for(int i=1;i<keys.count;i++)
//        {
//            content =[NSString stringWithFormat:@"%@&%@=%@",content,keys[i],[params objectForKey:keys[i]]];
//        }
//    NSLog(@"contentStr:%@",content);
//    if(![content isEqualToString:@""])
//        urlStr = [NSString stringWithFormat:@"%@?%@",urlStr,content];
    NSLog(@"urlStr:%@",urlStr);
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kTimeOutTime];
    request.HTTPMethod = @"GET";
    NSLog(@"&&&&& self.token:%@",self.token);
    
    [request setValue:self.token forHTTPHeaderField:@"X-Auth-Token"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[[NSOperationQueue alloc]init]];
    //创建网络任务
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error){
//        if (error) {
//            getFail =2;
//            dataMessage=@"数据获取错误，请稍后重试！";
//            if(block)
//            {
//                NSDictionary *dic = [[NSDictionary alloc]init];
//                block(getFail,dataMessage,dic);
//            }
//            return;
//        }
//
//         else {
            NSLog(@"rrrdata2:%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
             
            NSDictionary *dictionary=[self readJsonData:data];
            getFail = [[dictionary objectForKey:@"status"] integerValue];
            dataMessage=[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"message"]];
            if(block)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(getFail,dataMessage,dictionary);
                });
                
            }
//        }
        
    }];
    [dataTask resume];
}

-(void)connetNetWithPostMethod:(NSString *)handle parms:(NSDictionary *)params needToken:(BOOL)needToken block:(void (^)(int, NSString * _Nonnull, NSDictionary * _Nonnull))block{
    
}

#pragma mark - readJson
-(NSDictionary *)readJsonData:data
{
    NSError *error;
    NSDictionary *dictionary=[NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if(error)
    {
        NSLog(@"json解析失败:%@",error);
        return nil;
    }
    return dictionary;
    
}

@end
