//
//  MessageTabelViewController.m
//  nuonuo
//
//  Created by LXX on 2019/12/1.
//  Copyright © 2019年 LXX. All rights reserved.
//

#import "MessageTabelViewController.h"
#import "MessageTableViewCell.h"
#import "LxxInterfaceConnection.h"

#import "SDWebImage/UIImageView+WebCache.h"

@interface MessageTabelViewController ()<UITableViewDataSource,UITableViewDelegate>

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define fontColor [UIColor colorWithRed:25.0/255 green:0 blue:131.0/255 alpha:1.0]

#define kIs_iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define kIs_iPhoneX SCREEN_WIDTH >=375.0f && SCREEN_HEIGHT >=812.0f&& kIs_iphone
#define kStatusBarHeight (CGFloat)(kIs_iPhoneX?(44.0):(20.0))

@property (nonatomic, strong) UIView * menuView;
@property (nonatomic, strong) UIButton *firstButton;
@property (nonatomic, strong) UILabel *firstLabel;
@property (nonatomic, strong) UIButton *secondButton;
@property (nonatomic, strong) UILabel *secondLabel;

@property (nonatomic, strong) NSMutableArray * lineArr;                 /**< 选中红线数组 */

@property (nonatomic) CGFloat menuWidth;
@property (nonatomic) CGFloat menuHeight;


@property (nonatomic,strong) UITableView *tableView;
@property NSArray *dataSource;



@end

@implementation MessageTabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self dataConfiguration];
    
}


#pragma mark - Private DataConfiguration

-(void)dataConfiguration {

    self.navigationItem.title = @"消息";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:62.0/255 green:54.0/255 blue:139.0/255 alpha:1.0];
    
    
    self.lineArr = [[NSMutableArray alloc]init];
    self.dataSource = [[NSMutableArray alloc]init];
    
    self.menuHeight = 70;
    self.menuWidth =  SCREEN_WIDTH/ 2;
    self.menuView = [[UIView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,70)];
    self.menuView.backgroundColor = [UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1.0];
    [self.view addSubview:self.menuView];
    
    [self setupTwoTabButtonView];
    [self loadData];
    [self creatTable];
}

#pragma mark - Private SetupTwoTabButtonView
- (void)setupTwoTabButtonView {
    //firstButton
    self.firstButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,self.menuWidth,self.menuHeight)];
    self.firstButton.backgroundColor = [UIColor whiteColor];
    [self.firstButton setTitleColor:fontColor forState:UIControlStateHighlighted];
    [self.firstButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    
    self.firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(_menuWidth/2,0,60,self.menuHeight)];
    self.firstLabel.text = @"发送";
    self.firstLabel.textColor = fontColor;
    self.firstLabel.font = [UIFont systemFontOfSize:20];
    self.firstLabel.textAlignment = NSTextAlignmentCenter;
    [self.firstButton addSubview:self.firstLabel];
    
    UIImageView *firstView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"send"]];
    firstView.frame = CGRectMake(_menuWidth/2-35, _menuHeight/2-10, 29, 27);
    [self.firstButton addSubview:firstView];
    
    UILabel *firstline= [[UILabel alloc] initWithFrame:CGRectMake(25, self.menuHeight-1.4, self.menuWidth-50, 1.4)];
    firstline.layer.borderColor = fontColor.CGColor;
    firstline.layer.borderWidth = 0.7;
    [self.lineArr addObject:firstline];
    [self.firstButton addSubview:firstline];
    
    
    
    //secondButton
    self.secondButton = [[UIButton alloc] initWithFrame:CGRectMake(self.menuWidth,0,self.menuWidth,self.menuHeight)];
    self.secondButton.backgroundColor = [UIColor whiteColor];
    [self.secondButton addTarget:self action:@selector(receiveMessage) forControlEvents:UIControlEventTouchUpInside];
    self.secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(_menuWidth/2,0,60,self.menuHeight)];
    [self.secondButton setTitleColor:fontColor forState:UIControlStateHighlighted];
    
    self.secondLabel.text =  @"收到";
    self.secondLabel.textColor = fontColor;
    self.secondLabel.font = [UIFont systemFontOfSize:20];
    self.secondLabel.textAlignment = NSTextAlignmentCenter;
    [self.secondButton addSubview:self.secondLabel];
    
    UIImageView *secondView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"receive"]];
    secondView.frame = CGRectMake(_menuWidth/2-35, _menuHeight/2-10, 29, 27);
    [self.secondButton addSubview:secondView];
    
    UILabel *secondline= [[UILabel alloc] initWithFrame:CGRectMake(25, self.menuHeight-1.4, self.menuWidth-50, 1.4)];
    secondline.layer.borderColor = fontColor.CGColor;
    secondline.layer.borderWidth = 0.7;
    [self.lineArr addObject:secondline];
    [self.secondButton addSubview:secondline];
    [secondline setHidden:YES];
    
    
    [self.menuView addSubview:self.firstButton];
    [self.menuView addSubview:self.secondButton];

}

-(void)creatTable{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,self.menuHeight, SCREEN_WIDTH, SCREEN_HEIGHT -  self.navigationController.navigationBar.frame.size.height-kStatusBarHeight-self.menuView.frame.size.height-44) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    CGRect frame=CGRectMake(0, 0, 0, 5);
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:frame];
    self.tableView.backgroundColor = [UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1.0];
    [self.view addSubview:self.tableView];
    
    //NSLog(@"height%f",kStatusBarHeight);
}

-(void)sendMessage{
    [[self.lineArr objectAtIndex:1] setHidden:YES];
    [[self.lineArr objectAtIndex:0] setHidden:NO];
    
}
-(void)receiveMessage{
    [[self.lineArr objectAtIndex:0] setHidden:YES];
    [[self.lineArr objectAtIndex:1] setHidden:NO];
    
}

-(void)loadData{
    NSString *getStr = [NSString stringWithFormat:@"message"];
    
    NSMutableDictionary * parm = [[NSMutableDictionary alloc]init];
    LxxInterfaceConnection *connect = [[LxxInterfaceConnection alloc] init];
    [connect connetNetWithGetMethod:getStr parms:parm block:^(int fail,NSString *dataMessage,NSDictionary *dictionary) {
        if (fail ==0) {
            NSLog(@"search dataMessage：%@",dataMessage);
            
            self.dataSource = [dictionary objectForKey:@"data"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
                
            });
        }
    }];
    
    
}


#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
   //return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    view.backgroundColor = [UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1.0];
    return view;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageTableViewCell * cell = [MessageTableViewCell cellInit:self.tableView];
    
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = self.dataSource[indexPath.row];
    
    cell.nameLabel.text = [dic objectForKey:@"sendName"];
    cell.messageLabel.text = [dic objectForKey:@"content"];
    cell.messageLabel.text = [dic objectForKey:@"content"];
    NSString *headUrl = [dic objectForKey:@"headPicUrl"];
    if(![headUrl isEqualToString:@""]){
        [cell.headImage sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@"加载中"]];
    }
    
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}



@end
