//
//  SearchViewController.m
//  nuonuo
//
//  Created by LXX on 2019/11/21.
//  Copyright © 2019年 LXX. All rights reserved.
//

#import "SearchViewController.h"
#import "LxxInterfaceConnection.h"
#import "OwerViewController.h"

#import "GKCycleScrollView.h"
#import "GKPageControl.h"
#import <Masonry/Masonry.h>
#import "SDWebImage/UIImageView+WebCache.h"

#import "ToolCollect.h"
#import "UserInfo.h"


@interface SearchViewController ()<GKCycleScrollViewDataSource, GKCycleScrollViewDelegate>

@property (nonatomic) UIButton *returnBtn;

@property (nonatomic) GKCycleScrollView * cycleScrollView;

@property (nonatomic) NSInteger infoIndex;

@property (nonatomic) NSString * token ;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"]  style:UIBarButtonItemStyleDone target:self action:@selector(popAction)];
//    self.navigationItem.leftBarButtonItem = leftBarItem;
//
//    self.navigationItem.leftBarButtonItem = leftBarItem;
//    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
////    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:62.0/255 green:54.0/255 blue:139.0/255 alpha:1.0];


    [self dataConfiguration];
    //[self getDetail];
    [self setupView];
}

-(void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private DataConfiguration
- (void)dataConfiguration{
    NSData *deData = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    UserInfo * userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:deData];
    self.token = userInfo.accessToken;

    
    _returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _returnBtn.frame = CGRectMake(20, 40, 27, 22);
    [_returnBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    _returnBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [[_returnBtn imageView] setContentMode:UIViewContentModeScaleAspectFill];
    _returnBtn.contentHorizontalAlignment= UIControlContentHorizontalAlignmentFill;
    _returnBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    [_returnBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_returnBtn];
}

//-(void)getDetail{
//    NSString *getStr = [NSString stringWithFormat:@"photo/%@",@"sycnz"];
//
//    NSMutableDictionary * parm = [[NSMutableDictionary alloc]init];
//    LxxInterfaceConnection *connect = [[LxxInterfaceConnection alloc] init];
//    [connect connetNetWithGetMethod:getStr parms:parm block:^(int fail,NSString *dataMessage,NSDictionary *dictionary) {
//        if (fail ==0) {
//            NSLog(@"search dataMessage：%@",dataMessage);
//
//            //获取匹配到的车信息
//            self.infoArr = [dictionary objectForKey:@"data"];
//
//            NSLog(@"search arr：%@",self.infoArr);
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//                [self setupView];
//            });
//        }
//    }];
//}

-(void)setupView{
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(SCREEN_WIDTH/2-32,SCREEN_HEIGHT-100, 64, 64);
    [confirmBtn setImage:[UIImage imageNamed:@"打勾"] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
    
    [self scrollView];
}
//车牌匹配的结果
-(void)scrollView{
    GKCycleScrollView *cycleScrollView = [[GKCycleScrollView alloc] init];
    cycleScrollView.dataSource = self;
    cycleScrollView.delegate = self;
    cycleScrollView.minimumCellAlpha = 0.0;
    cycleScrollView.leftRightMargin = 20.0f;
    cycleScrollView.topBottomMargin = 20.0f;
    cycleScrollView.isAutoScroll = NO;
    //cycleScrollView.frame = CGRectMake(0, 10, self.view.frame.size.width, 500);
    [self.view addSubview:cycleScrollView];
    
    self.cycleScrollView = cycleScrollView;
    
    GKPageControl *pageControl = [[GKPageControl alloc] init];
    //pageControl.frame = CGRectMake(0, cycleScrollView.frame.size.height-70, SCREEN_WIDTH, 30);
    //pageControl3.style = GKPageControlStyleSizeDot;
    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:157/255.0 green:157/255.0 blue:157/255.0 alpha:1.0];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:25.0/255 green:0 blue:131.0/255 alpha:1.0];
    cycleScrollView.pageControl = pageControl;
    [cycleScrollView addSubview:pageControl];
    [cycleScrollView reloadData];
    
    
    [cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.returnBtn.mas_bottom).offset(5.0f);
        make.height.mas_equalTo(SCREEN_HEIGHT/3*2+10);
    }];
    
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cycleScrollView);
        make.bottom.equalTo(cycleScrollView);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(10.0f);
    }];
}

-(void)confirmAction{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic = self.infoArr[self.infoIndex];
    
    OwerViewController *ovc = [[OwerViewController alloc]init];
    ovc.owerId = [dic objectForKey:@"id"];
    [self.navigationController pushViewController:ovc animated:YES];
}

#pragma mark - GKCycleScrollViewDataSource
- (NSInteger)numberOfCellsInCycleScrollView:(GKCycleScrollView *)cycleScrollView {
    return self.infoArr.count;
}

- (GKCycleScrollViewCell *)cycleScrollView:(GKCycleScrollView *)cycleScrollView cellForViewAtIndex:(NSInteger)index {
    GKCycleScrollViewCell *cell = [cycleScrollView dequeueReusableCell];
    if (!cell) {
        cell = [GKCycleScrollViewCell new];
        cell.layer.cornerRadius = 15;
        cell.layer.masksToBounds = YES;
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic = self.infoArr[index];
    NSLog(@"dic: %@",dic);
    
    //NSString *headStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"otherPicNames"]];
    //[cell.imageView sd_setImageWithURL:[NSURL URLWithString:headStr]];
    
//    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:headStr]  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//
//        [self.cycleScrollView reloadData];
//    }];
    
    
    NSString *headStr = [NSString stringWithFormat:@"%@",@"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=2379750824,3935342609&fm=26&gp=0.jpg"];
    
    NSLog(@"headstr: %@",headStr);
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    return cell;
}
#pragma mark - GKCycleScrollViewDelegate
- (CGSize)sizeForCellInCycleScrollView:(GKCycleScrollView *)cycleScrollView {
    return CGSizeMake(ceilf(kAdapter(560.0f)), kAdapter(850.0f));
}

- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didScrollCellToIndex:(NSInteger)index {
    self.infoIndex = index;
    
    
}


@end
