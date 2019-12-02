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

@property (nonatomic) NSString * POST_ID;

@end

const CGFloat kTimeOutTime = 10.f;

@implementation LxxInterfaceConnection

-(NSString *)POST_ID {
    if(_POST_ID) {
        return _POST_ID;
    } else {
        return @"iOS";
    }
}

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
    
//    [request setValue:self.token forHTTPHeaderField:@"X-Auth-Token"];
    [request setValue:self.token forHTTPHeaderField:@"Authorization"];
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
-(void)connetNetWithPutMethod:(NSString *)handle parms:(NSDictionary *)params block:(void (^)(int, NSString *, NSDictionary *))block  {
    __block BOOL getFail=0;
    __block NSString *dataMessage;
    NSString *urlStr = [NSString stringWithFormat:NetURL,handle];
    //设置请求头参数
    NSString *content = @"";
    //    if(keys.count>0) {
    //        content = [NSString stringWithFormat:@"%@=%@",keys[0],[params objectForKey:keys[0]]];
    //    }
    //    if(keys.count>1) {
    //        for(int i=1;i<keys.count;i++) {
    //            content =[NSString stringWithFormat:@"%@&%@=%@",content,keys[i],[params objectForKey:keys[i]]];
    //        }
    //    }
    NSLog(@"contentStr:%@",content);
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kTimeOutTime];
    request.HTTPMethod = @"PUT";
    content = [self convertToJsonData:params];
    NSLog(@"contentStr:%@",content);
    NSData * data = [content dataUsingEncoding:NSUTF8StringEncoding];

//    //设置请求头参数
//    NSArray *keys=[params allKeys];
//    NSString *myContent = @"";
//    if(keys.count>0)
//        myContent = [NSString stringWithFormat:@"%@=%@",keys[0],[params objectForKey:keys[0]]];
//    if(keys.count>1) {
//        for(int i=1;i<keys.count;i++) {
//            myContent =[NSString stringWithFormat:@"%@&%@=%@",myContent,keys[i],[params objectForKey:keys[i]]];
//        }
//    }
//    NSLog(@"contentStr:%@",myContent);
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:self.token forHTTPHeaderField:@"Authorization"];
//    NSLog(@"token:%@",self.token);
//
//    NSData *myData = [myContent dataUsingEncoding:NSUTF8StringEncoding];
//    request.HTTPBody = myData;
    
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:self.token forHTTPHeaderField:@"Authorization"];
    request.HTTPBody = data;

    NSURLSession *sess = [NSURLSession sharedSession];
    //创建网络任务
    NSURLSessionDataTask *dataTask = [sess dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error){
        NSLog(@"rrrdata:%@",error);
        NSLog(@"handle:%@",handle);
        
        NSDictionary *dictionary=[self readJsonData:data];
        getFail = [[dictionary objectForKey:@"status"] integerValue];
        dataMessage=[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"message"]];

            if(block) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(getFail,dataMessage,dictionary);
                });
                
            }
        
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



-(void)sendImageWithImage:(UIImage *)img block:(void(^)(NSString * imageId ,BOOL isFailed))block{
    NSData *imageData;
    NSString *imageFormat;
    if (UIImagePNGRepresentation(img) != nil) {
        imageFormat = @"Content-Type: image/png \r\n";
        imageData = UIImagePNGRepresentation(img);
        
    }else{
        imageFormat = @"Content-Type: image/jpeg \r\n";
        imageData = UIImageJPEGRepresentation(img, 0.5);
        
    }
    NSString *string =[NSString stringWithFormat:@"http://xyt.fzu.edu.cn:54321/v1/%@",@"files"];
    NSURL *url = [NSURL URLWithString:string];
    //NSURL *url = [NSURL URLWithString:@"http://api.fzuxyt.com/v1/files"];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kTimeOutTime];
    request.HTTPMethod = @"POST";
    //设置请求实体
    NSMutableData *body = [NSMutableData data];
    
    ///文件参数
    [body appendData:[self getDataWithString:@"--BOUNDARY\r\n" ]];
    NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@.jpg\"\r\n",self.POST_ID];
    [body appendData:[self getDataWithString:disposition ]];
    [body appendData:[self getDataWithString:imageFormat]];
    [body appendData:[self getDataWithString:@"\r\n"]];
    [body appendData:imageData];
    [body appendData:[self getDataWithString:@"\r\n"]];
    //普通参数
    [body appendData:[self getDataWithString:@"--BOUNDARY\r\n" ]];
    //上传参数需要key： （相应参数，在这里是_myModel.personID）
    NSString *dispositions = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n",@"key"];
    [body appendData:[self getDataWithString:dispositions ]];
    [body appendData:[self getDataWithString:@"\r\n"]];
    [body appendData:[self getDataWithString:_POST_ID]];
    [body appendData:[self getDataWithString:@"\r\n"]];
    
    //参数结束
    [body appendData:[self getDataWithString:@"--BOUNDARY--\r\n"]];
    request.HTTPBody = body;
    //设置请求体长度
    NSInteger length = [body length];
    [request setValue:[NSString stringWithFormat:@"%ld",(long)length] forHTTPHeaderField:@"Content-Length"];
    //设置 POST请求文件上传
    [request setValue:@"multipart/form-data; boundary=BOUNDARY" forHTTPHeaderField:@"Content-Type"];
    
    if(![request valueForHTTPHeaderField:@"Authorization"])
    {
        [request setValue:self.token forHTTPHeaderField:@"Authorization"];
    }
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"rrrdata:%@",error);
        if(error)
        {
            NSLog(@"出现异常:%@",error);
            //                    if(!block)
            //                    {
            block(nil,NO);
            //                    }
        }
        else
        {
            NSJSONSerialization *object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSDictionary *dict = (NSDictionary *)object;
            NSLog(@"=====%@",[dict objectForKey:@"status"]);
            NSString *status = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
            if([status isEqualToString:@"0"])
            {
                NSLog(@"服务器成功响应!>>%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                NSDictionary *dictionary=[self readJsonData:data];
                block([[dictionary objectForKey:@"data"] objectForKey:@"id"],YES);
            }
            else
            {
                NSLog(@"服务器返回失败!>>%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                block(nil,NO);
            }
        }
        
    }];
    //开始任务
    [dataTask resume];
    
}


-(NSData *)getDataWithString:(NSString *)string{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    return data;
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
