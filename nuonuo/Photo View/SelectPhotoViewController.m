//
//  SelectPhotoViewController.m
//  nuonuo
//
//  Created by LXX on 2019/11/22.
//  Copyright © 2019年 LXX. All rights reserved.
//

#import "SelectPhotoViewController.h"
#import "SearchViewController.h"
#import "LxxInterfaceConnection.h"
#import "OwerViewController.h"

@interface SelectPhotoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *idLabel;


@end

@implementation SelectPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.carImageView.image = self.image;
    
    UIButton * returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(20, 40, 27, 22);
    [returnBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    returnBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [[returnBtn imageView] setContentMode:UIViewContentModeScaleAspectFill];
    returnBtn.contentHorizontalAlignment= UIControlContentHorizontalAlignmentFill;
    returnBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    [returnBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnBtn];
    
    [self sendOCRRequest:self.image];
    
}

- (IBAction)confirmAction:(UIButton *)sender {
    if([self.idLabel.text isEqualToString:@"未能识别车牌，请重试"]||[self.idLabel.text isEqualToString:@"车牌号"]){
        return;
    }
    
    NSString *inputCarID = [NSString stringWithFormat:@"%@",self.idLabel.text];;
    NSString *getStr = [NSString stringWithFormat:@"photo/%@",inputCarID];
    
    NSMutableDictionary * parm = [[NSMutableDictionary alloc]init];
    LxxInterfaceConnection *connect = [[LxxInterfaceConnection alloc] init];
    [connect connetNetWithGetMethod:getStr parms:parm block:^(int fail,NSString *dataMessage,NSDictionary *dictionary) {
        if (fail ==0) {
            NSLog(@"search dataMessage：%@",dataMessage);
            
            //获取匹配到的车信息
            NSMutableArray *arr = [[NSMutableArray alloc]init];
            arr = [dictionary objectForKey:@"data"];
            NSLog(@"search arr：%@",arr);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(arr.count == 0){//无相关信息
                    UIAlertController *sorryAlert = [UIAlertController alertControllerWithTitle:nil message:@"sorry~未找到该车主呢" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
                    [sorryAlert addAction:confirmAction];
                    [self presentViewController:sorryAlert animated:YES completion:nil];
                    
                }else{
                    SearchViewController *svc = [[SearchViewController alloc]init];
                    svc.infoArr = arr;
                    svc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:svc animated:YES];
                }
                
            });
        }
    }];
    
//    SearchViewController *svc = [[SearchViewController alloc]init];
//    svc.carID = [NSString stringWithFormat:@"%@",self.idLabel.text];
//    [self.navigationController pushViewController:svc animated:YES];
}

-(void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)change:(UIImage*)image{
    //UIImage图片转Base64字符串：
    
    UIImage *originImage = image;
    
    NSData *imgData = UIImageJPEGRepresentation(originImage, 1.0f);
    
    NSString *encodedImageStr = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    //Base64字符串转UIImage图片：
    
    NSData *decodedImageData = [[NSData alloc]initWithBase64EncodedString:encodedImageStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
    //self.imageView.image = decodedImage;
    return [self urlEncodeStr:encodedImageStr];
    
}
/**
 *  URLEncode
 */
- (NSString *)urlEncodeStr:(NSString *)input{
    NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *upSign = [input stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    return upSign;
}

/**
 *  URLDecode
 */
-(NSString *)URLDecodedStringWithEncodedStr:(NSString *)encodedString{
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,(__bridge CFStringRef)encodedString,CFSTR(""),CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}
- (void)sendOCRRequest:(UIImage *)image{
    NSDictionary *headers = @{ @"Content-Type": @"application/x-www-form-urlencoded",
                               @"cache-control": @"no-cache",
                               @"Postman-Token": @"62eed723-01d9-4ad8-849a-73d99417edc3" };
    
    NSString *str1 = @"image=";
    NSString *str  = [str1 stringByAppendingFormat:@"%@", [self change:image]];
    NSMutableData *postData = [[NSMutableData alloc] initWithData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    //[postData appendData:[@"&detect_direction=true" dataUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://aip.baidubce.com/rest/2.0/ocr/v1/general_basic?access_token=24.75b832dfb59d0baef0999680113c2973.2592000.1576852660.282335-17818844"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSLog(@"%@", httpResponse);
                                                        NSString * str  =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                        NSLog(@"%@",str);
                                                        
                                                        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
//                                                            //self.textView.text = str;

                                                            NSArray *arr = [[NSArray alloc]init];
                                                            arr = [dict objectForKey:@"words_result"];
                                                            
                                                            for(NSDictionary *dic in arr ){
                                                                NSString *numStr =[dic objectForKey:@"words"];
                                                                NSLog(@"num  %@--%lu",numStr,(unsigned long)numStr.length);
                                                                if (numStr.length == 5) {
                                                                    self.idLabel.text = [dic objectForKey:@"words"];
                                                                    break;
                                                                }
                                                            }
                                                            if([self.idLabel.text isEqualToString:@"车牌号"]){
                                                                self.idLabel.text = @"未能识别车牌，请重试";
                                                            }
                                                            
                                                            
//                                                            NSDictionary *dic =
//                                                            dic = arr[1];
//
//                                                            self.idLabel.text = [dic objectForKey:@"words"];
                                                            
                                                        });
                                                    }
                                                }];
    [dataTask resume];
}

@end
