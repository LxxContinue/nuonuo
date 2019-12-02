//
//  BindViewController.m
//  nuonuo
//
//  Created by LXX on 2019/11/22.
//  Copyright © 2019年 LXX. All rights reserved.
//

#import "BindViewController.h"

#import "LxxInterfaceConnection.h"
#import "UIViewController+XHPhoto.h"
#import "SelectPhotoViewController.h"

#import "SDWebImage/UIImageView+WebCache.h"

@interface BindViewController ()
@property (weak, nonatomic) IBOutlet UIButton *photoBtn;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (nonatomic, strong) NSString *carImageID;                      /**< 图片上传返回ID */
@property (nonatomic, strong) NSString *carID;                           /**< 车车ID */

@end

static const CGFloat kTimeOutTime = 10.f;

@implementation BindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.Binding){
        self.navigationItem.title = @"已绑定";
    }else {
        self.navigationItem.title = @"未绑定";
    }
    
    //self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]}; 
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:62.0/255 green:54.0/255 blue:139.0/255 alpha:1.0];
    
    [self.photoBtn addTarget:self action:@selector(photoAction) forControlEvents:UIControlEventTouchUpInside];
    [self.confirmBtn addTarget:self action:@selector(corfirmAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.confirmBtn.hidden = YES;
    if(self.Binding){
        self.photoBtn.hidden = YES;
        
        if(![self.carPicStr isEqualToString:@""]){
            [self.photoView sd_setImageWithURL:[NSURL URLWithString:self.carPicStr] placeholderImage:[UIImage imageNamed:@"加载中"]];
        }
    }
    
    NSLog(@"token :%@",self.token);
}

-(void)corfirmAction{
    NSString *msg = [NSString stringWithFormat:@"\n确定要绑定车车吗？"];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self upload];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:defaultAction];
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

-(void)photoAction{
    [self chooseHeaderImage];
    
}

- (void)chooseHeaderImage {
    //选择图片
    [self showCanEdit:YES photo:^(UIImage *image) {
        NSData *originData = UIImageJPEGRepresentation(image, 1.0f);
        UIImage *resultImage;
        if (originData.length > 1000) {
            if(image.size.width > 1000) {
                CGFloat ratio = image.size.height / image.size.width;
                CGFloat width = 1000;
                CGFloat height = ratio * width;
                CGSize toSize = CGSizeMake(width, height);
                resultImage = [self imageWithImageSimple:image scaledToSize:toSize];
            } else {
                resultImage = image;
            }
            NSData *data = UIImageJPEGRepresentation(resultImage, 1.0f);
            if(data.length > 1000) {
                data = [self convertImage:resultImage];
            }
            resultImage = [UIImage imageWithData:data];
        } else {
            resultImage = [UIImage imageWithData:originData];
        }
        LxxInterfaceConnection* picConnect = [[LxxInterfaceConnection alloc] init];
        [picConnect sendImageWithImage:resultImage  block:^(NSString *imageId ,BOOL isFailed) {
            //            [LCProgressHUD hide];
            if(!isFailed) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //                    [LCProgressHUD showFailure:@"头像上传失败，请重试"];
                    NSLog(@"头像上传失败，请重试");
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        //                        [LCProgressHUD hide];
                    });
                    //                    self.tableView.userInteractionEnabled = YES;
                    //                    self.headerImageView.image = beforeImage;
                    //                    self.isFailed = YES;
                });
                return;
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //                    [LCProgressHUD showSuccess:@"头像上传成功"];
                    //                    self.headImageModify = true;
                    NSLog(@"头像上传成功");
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        //                        [LCProgressHUD hide];
                        self.photoView.image = image;
                        self.photoBtn.hidden = YES;
                        self.confirmBtn.hidden = NO;
                        
                        self.carID = @"synz2";
                        self.carImageID = imageId;
                        
                        NSLog(@"photo id %@",imageId);
                    });
                    //                    self.tableView.userInteractionEnabled = YES;
                    //                    self.isFailed = NO;
                    //                    self.headerImageID = imageId;
                    //                    self.isReady = YES;
                    
                });
            }
        }];
    }];
}
- (NSData *)convertImage:(UIImage *)image {
    CGFloat lowRate = 0.0, highRate = 1.0;
    for (int i = 0; i < 16; ++i) {
        CGFloat midRate = (lowRate + highRate) * 0.5;
        NSData *midData = UIImageJPEGRepresentation(image, midRate);
        if (midData.length < 1000) {
            lowRate = midRate;
        } else {
            highRate = midRate;
        }
    }
    NSData *result = UIImageJPEGRepresentation(image, lowRate);
    return result;
}

- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)upload{

    NSURL *url = [NSURL URLWithString:@"http://xyt.fzu.edu.cn:54321/v1/photo/upload"];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kTimeOutTime];
    request.HTTPMethod = @"POST";
    
    //[request setValue:self.token forHTTPHeaderField:@"X-Auth-Token"];
    [request setValue:self.token forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.carID forKey:@"photoId"];
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    [arr addObject:self.carImageID];
    
    [dic setObject:arr  forKey:@"imageIds"];

    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    request.HTTPBody = data;
    
    //    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[[NSOperationQueue alloc]init]];
    
    __block  NSString *result = @"";
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {

            result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"返回正确：%@",result);
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            NSLog(@"upload 返回正确：%@",arr);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else{
            NSLog(@"错误信息：%@",error);
        }
    }];
    [dataTask resume];
    
}


@end
